//
//  TerrainNode.swift
//  Meadow
//
//  Created by Zack Brown on 27/04/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import SceneKit

public class TerrainNode<Layer: TerrainLayer>: GridNode, GridParent, GridIntermediateLoader {
    
    public typealias ChildType = Layer
    public typealias IntermediateType = TerrainLayerIntermediate
    
    public var children: [Layer] = []
    
    public var intersections: [Polyhedron] = []
    
    enum CodingKeys: CodingKey {
        
        case children
    }
    
    public override func encode(to encoder: Encoder) throws {
        
        try super.encode(to: encoder)
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(self.children, forKey: .children)
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
            
            let polyhedrons = Polyhedron.subtract(polyhedrons: intersections, from: layer.polyhedron)
            
            GridEdge.Edges.forEach { edge in
                
                let (c0, c1) = GridCorner.corners(edge: edge)
                
                let edgeNormal = GridEdge.normal(edge: edge)
                
                let terrainType = layer.get(terrainType: edge)
                
                let apexColor = terrainType.colorPalette?.primary.vector ?? SCNVector4Zero
                let edgeColor = terrainType.colorPalette?.secondary.vector ?? SCNVector4Zero
                
                polyhedrons.forEach { polyhedron in
                    
                    let v0 = polyhedron.upperPolytope.vertices[c0.rawValue]
                    let v1 = polyhedron.upperPolytope.vertices[c1.rawValue]
                    
                    if (layer.hierarchy.upper == nil || layer.hierarchy.upper?.lowerPolytope != polyhedron.upperPolytope) {
                        
                        meshFaces.append(MeshProvider.surface(corners: (c0, c1), polytope: polyhedron.upperPolytope, color: apexColor))
                    }
                    
                    let divisions = (stencils[edge] != nil ? Polyhedron.stencil(polyhedrons: stencils[edge]!, against: polyhedron, edge: edge) : [polyhedron])
                    
                    divisions.forEach { division in
                        
                        let v2 = division.upperPolytope.vertices[c0.rawValue]
                        let v3 = division.upperPolytope.vertices[c1.rawValue]
                        let v4 = division.lowerPolytope.vertices[c1.rawValue]
                        let v5 = division.lowerPolytope.vertices[c0.rawValue]
                        
                        let c0equal = Axis.Y(y: v2.y) == Axis.Y(y: v5.y)
                        let c1equal = Axis.Y(y: v3.y) == Axis.Y(y: v4.y)
                        
                        let acuteCorner = (c0equal ? c0 : (c1equal ? c1 : nil))
                        
                        if !c0equal || !c1equal {
                            
                            let p0equal = Axis.Y(y: v0.y) == Axis.Y(y: v2.y)
                            let p1equal = Axis.Y(y: v1.y) == Axis.Y(y: v3.y)
                            
                            if p0equal && p1equal {
                                
                                meshFaces.append(contentsOf: TerrainMeshProvider.terrainLayer(crown: (c0, c1), acuteCorner: acuteCorner, polyhedron: division, normal: edgeNormal, color: apexColor))
                                meshFaces.append(contentsOf: TerrainMeshProvider.terrainLayer(throne: (c0, c1), acuteCorner: acuteCorner, polyhedron: division, normal: edgeNormal, color: edgeColor))
                            }
                            else {
                                
                                meshFaces.append(contentsOf: MeshProvider.edge(corners: (c0, c1), polyhedron: division, normal: edgeNormal, color: edgeColor))
                            }
                        }
                    }
                }
            }
        }
        
        return Mesh(faces: meshFaces)
    }
}

extension TerrainNode {
    
    public func load(nodes: [TerrainLayerIntermediate]) {
        
        nodes.forEach { intermediate in
            
            if let layer = add(layer: TerrainType.bedrock) {
                
                let edges = [intermediate.edges.north, intermediate.edges.east, intermediate.edges.south, intermediate.edges.west]
                
                for index in 0..<intermediate.corners.count {
                    
                    layer.set(terrainType: TerrainType(rawValue: edges[index].terrainType)!, edge: edges[index].edge)
                    
                    layer.set(height: intermediate.corners[index], corner: GridCorner(rawValue: index)!)
                }
            }
        }
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
