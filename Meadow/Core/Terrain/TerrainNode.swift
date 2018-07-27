//
//  TerrainNode.swift
//  Meadow
//
//  Created by Zack Brown on 27/04/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

public class TerrainNode<Layer: TerrainLayer>: GridNode, GridParent {
    
    public typealias ChildType = Layer
    
    public var children: [Layer] = []
    
    public var intersections: [Polyhedron] = []
    
    enum CodingKeys: CodingKey {
        
        case layers
    }
    
    public override func encode(to encoder: Encoder) throws {
        
        try super.encode(to: encoder)
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(self.children, forKey: .layers)
    }
    
    public override func becomeDirty() {
        
        if !isDirty {
            
            isDirty = true
        }
    }
    
    public override func clean() {
        
        if !isDirty { return }
        
        children.forEach { layer in
            
            layer.clean()
        }
        
        isDirty = false
    }
    
    public override var mesh: Mesh {
        
        var stencils: [GridEdge: [Polyhedron]] = [:]
        
        GridEdge.Edges.forEach { edge in
            
            if let neighbour = find(neighbour: edge)?.node as? TerrainNode, let upperPolytope = neighbour.topLayer?.polyhedron.upperPolytope, let lowerPolytope = neighbour.bottomLayer?.polyhedron.lowerPolytope {
                
                let polyhedron = Polyhedron(upperPolytope: upperPolytope, lowerPolytope: lowerPolytope)
                
                if neighbour.intersections.count > 0 {
                    
                    stencils[edge] = Polyhedron.subtract(polyhedrons: neighbour.intersections, from: polyhedron)
                }
                else {
                    
                    stencils[edge] = [polyhedron]
                }
            }
        }
        
        var meshFaces: [MeshFace] = []
        
        children.filter { !$0.isHidden }.forEach { layer in
            
            GridEdge.Edges.forEach { edge in
                
                let corners = GridCorner.corners(edge: edge)
                
                let edgeNormal = GridEdge.normal(edge: edge)
                
                let terrainType = layer.get(terrainType: edge)
                
                let apexColor = terrainType.colorPalette.primary.vector
                let edgeColor = terrainType.colorPalette.secondary.vector
                
                let meshProvider = terrainType.meshProvider
                
                let polyhedrons = Polyhedron.subtract(polyhedrons: intersections, from: layer.polyhedron)
                
                polyhedrons.forEach { polyhedron in
                 
                    if (layer.hierarchy.upper == nil && layer.polyhedron.upperPolytope == polyhedron.upperPolytope) || layer.polyhedron.upperPolytope != polyhedron.upperPolytope {
                        
                        let v0 = polyhedron.upperPolytope.vertices[corners.first!.rawValue]
                        let v1 = polyhedron.upperPolytope.vertices[corners.last!.rawValue]
                        let v2 = polyhedron.upperPolytope.center
                        
                        meshFaces.append(meshProvider.terrainLayer(apex: [v0, v1, v2], color: apexColor))
                    }
                    
                    let divisions = (stencils[edge] != nil ? Polyhedron.stencil(polyhedrons: stencils[edge]!, against: polyhedron, edge: edge) : [polyhedron])
                    
                    divisions.forEach { division in
                        
                        let v0 = division.upperPolytope.vertices[corners.first!.rawValue]
                        let v1 = division.upperPolytope.vertices[corners.last!.rawValue]
                        let v2 = division.lowerPolytope.vertices[corners.last!.rawValue]
                        let v3 = division.lowerPolytope.vertices[corners.first!.rawValue]
                        
                        let c0equal = v0.y == v3.y
                        let c1equal = v1.y == v2.y
                        
                        let acuteCorner = (c0equal ? corners.first : (c1equal ? corners.last : nil))
                        
                        if !c0equal || !c1equal {
                            
                            let vertices = [v0, v1, v2, v3]
                            
                            meshFaces.append(contentsOf: meshProvider.terrainLayer(crown: corners, acuteCorner: acuteCorner, vertices: vertices, normal: edgeNormal, color: edgeColor))
                            meshFaces.append(contentsOf: meshProvider.terrainLayer(throne: corners, acuteCorner: acuteCorner, vertices: vertices, normal: edgeNormal, color: edgeColor))
                        }
                    }
                }
            }
        }
        
        return Mesh(faces: meshFaces)
    }
}

extension TerrainNode {
    
    public var totalChildren: Int { return children.count }
    
    public func child(at index: Int) -> SceneGraphChild? {
        
        return children[index]
    }
    
    public func index(of child: SceneGraphChild) -> Int? {
        
        guard let child = child as? ChildType else { return nil }
        
        return children.index(of: child)
    }
    
    public func child(didBecomeDirty child: SceneGraphChild) {
        
        let _ = becomeDirty()
        
        observer?.child(didBecomeDirty: child)
    }
}

extension TerrainNode {
    
    public var topLayer: Layer? {
        
        return children.first { layer -> Bool in
            
            return layer.hierarchy.upper == nil
        }
    }
    
    public var bottomLayer: Layer? {
        
        return children.first { layer -> Bool in
            
            return layer.hierarchy.lower == nil
        }
    }
    
    public func add(layer terrainType: TerrainType) -> TerrainLayer? {
        
        if let topLayer = topLayer, Axis.Y(y: topLayer.polyhedron.upperPolytope.base) == World.ceiling {
            
            return nil
        }
        
        let height = (World.floor + 1)
        
        let corners = topLayer?.polyhedron.upperPolytope.vertices.map { Axis.Y(y: $0.y) + 1 } ?? [height, height, height, height]
        
        guard let layer = Layer(observer: self, coordinate: volume.coordinate, corners: corners, terrainType: terrainType) else { return nil }
        
        layer.hierarchy.lower = topLayer
    
        topLayer?.hierarchy.upper = layer
    
        children.append(layer)
    
        becomeDirty()
    
        return layer
    }
    
    public func remove(layer: TerrainLayer) -> Bool {
        
        if let index = index(of: layer) {
            
            let upper = layer.hierarchy.upper
            let lower = layer.hierarchy.lower
            
            upper?.hierarchy.lower = lower
            
            lower?.hierarchy.upper = upper
            
            layer.hierarchy.upper = nil
            layer.hierarchy.lower = nil
        
            children.remove(at: index)
            
            becomeDirty()
            
            return true
        }
        
        return false
    }
}

extension TerrainNode: TerrainNodeIntersectionProvider {
    
    public func add(intersection polyhedron: Polyhedron) -> Bool {
        
        let intersection = intersections.first {
            
            let elevation = $0.elevation(referencing: polyhedron)
            
            return elevation == .equal || elevation == .intersecting
        }
        
        if intersection == nil {
            
            intersections.append(polyhedron)
            
            becomeDirty()
            
            return true
        }
        
        return false
    }
    
    public func remove(intersection polyhedron: Polyhedron) -> Bool {
        
        if let index = intersections.index(of: polyhedron) {
            
            intersections.remove(at: index)
            
            becomeDirty()
            
            return true
        }
        
        return false
    }
}
