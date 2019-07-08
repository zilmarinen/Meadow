//
//  TerrainNode.swift
//  Meadow
//
//  Created by Zack Brown on 27/04/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import SceneKit

public class TerrainNode<NodeEdge: TerrainNodeEdge<TerrainNodeEdgeLayer>>: GridNode, SceneGraphParent {
    
    var children = Tree<NodeEdge>()
    
    public var cutaways: [TerrainCutaway] = []
    
    private enum CodingKeys: CodingKey {
        
        case children
    }
    
    public override func encode(to encoder: Encoder) throws {
        
        try super.encode(to: encoder)
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(self.children.children, forKey: .children)
    }
    
    @discardableResult public override func clean() -> Bool {
        
        if !isDirty { return false }
        
        children.forEach { edge in
            
            edge.clean()
        }
        
        isDirty = false
        
        return true
    }
    
    public override func child(didBecomeDirty child: SceneGraphChild) {
        
        super.child(didBecomeDirty: child)
        
        guard let child = child as? NodeEdge else { return }
        
        find(neighbour: child.edge)?.node.becomeDirty()
    }
    
    public override var mesh: Mesh {
        
        var faces: [MeshFace] = []
        
        for edgeIndex in 0..<children.count {
        
            let nodeEdge = children[edgeIndex]
            
            guard !nodeEdge.isHidden else { continue }
            
            let (c0, c1) = GridCorner.corners(edge: nodeEdge.edge)
            
            let edgeNormal = GridEdge.normal(edge: nodeEdge.edge)
            let inverseNormal = SCNVector3.negate(vector: edgeNormal)
            
            let neighbourNode = find(neighbour: nodeEdge.edge)?.node as? TerrainNode
            
            let edgeStencils = (neighbourNode?.stencils(edge: GridEdge.opposite(edge: nodeEdge.edge)) ?? [])
            
            for layerIndex in 0..<nodeEdge.children.count {
                
                let layer = nodeEdge.children[layerIndex]
                
                guard let colorPalette = layer.terrainType.colorPalette, !layer.isHidden else { continue }
                
                let polyhedrons = Polyhedron.subtract(polyhedrons: cutaways, from: layer.polyhedron)
                
                polyhedrons.forEach { polyhedron in
                    
                    if layer.upper == nil || layer.upper?.lowerPolytope != polyhedron.upperPolytope {
                        
                        faces.append(MeshFace.apex(corners: (c0: c0, c1: c1), polytope: polyhedron.upperPolytope, color: colorPalette.primary.vector))
                    }
                    
                    let stencils = Polyhedron.subtract(polyhedrons: edgeStencils, from: polyhedron)
                    
                    stencils.forEach { stencil in
                        
                        let c0equal = Axis.Y(y: polyhedron.upperPolytope.vertices[c0.rawValue].y) == Axis.Y(y: stencil.upperPolytope.vertices[c0.rawValue].y)
                        let c1equal = Axis.Y(y: polyhedron.upperPolytope.vertices[c1.rawValue].y) == Axis.Y(y: stencil.upperPolytope.vertices[c1.rawValue].y)
                        
                        if c0equal && c1equal {
                            
                            faces.append(contentsOf: MeshFace.edge(crown: (c0: c0, c1: c1), polyhedron: stencil, normal: edgeNormal, color: colorPalette.tertiary.vector))
                            faces.append(contentsOf: MeshFace.edge(throne: (c0: c0, c1: c1), polyhedron: stencil, normal: edgeNormal, color: colorPalette.secondary.vector))
                        }
                        else {
                            
                            faces.append(contentsOf: MeshFace.edge(corners: (c0: c0, c1: c1), polyhedron: stencil, normal: edgeNormal, color: colorPalette.secondary.vector))
                        }
                    }
                    
                    let (e0, e1) = GridEdge.edges(edge: nodeEdge.edge)
                    
                    [e0, e1].forEach { edge in
                        
                        let diagonalNormal = inverseNormal + GridEdge.normal(edge: edge)
                    
                        let (c2, c3) = GridCorner.corners(edge: edge)
                        
                        let corner = (c2 == c0 ? c2 : (c2 == c1 ? c2 : c3))
                        
                        let cornerUpper = polyhedron.upperPolytope.vertices[corner.rawValue]
                        let centreUpper = polyhedron.upperPolytope.center
                        
                        var cornerLower = polyhedron.lowerPolytope.vertices[corner.rawValue]
                        var centerLower = polyhedron.lowerPolytope.center
                        
                        if let diagonalPolytope = find(edge: edge)?.topLayer?.upperPolytope {
                            
                            cornerLower = (diagonalPolytope.vertices[corner.rawValue].y > cornerLower.y ? diagonalPolytope.vertices[corner.rawValue] : cornerLower)
                            
                            centerLower = (diagonalPolytope.center.y > centerLower.y ? diagonalPolytope.center : centerLower)
                        }
                        
                        if cornerUpper.y > cornerLower.y || centreUpper.y > centerLower.y {
                            
                            let polytope = Polytope(v0: cornerUpper, v1: centreUpper, v2: centerLower, v3: cornerLower)
                            
                            if layer.upper == nil || layer.upper?.lowerPolytope != polyhedron.upperPolytope {
                                
                                faces.append(contentsOf: MeshFace.diagonal(crown: polytope, normal: diagonalNormal, color: colorPalette.tertiary.vector))
                                faces.append(contentsOf: MeshFace.diagonal(throne: polytope, normal: diagonalNormal, color: colorPalette.secondary.vector))
                            }
                            else {
                                
                                faces.append(contentsOf: MeshFace.diagonal(polytope: polytope, normal: diagonalNormal, color: colorPalette.secondary.vector))
                            }
                        }
                    }
                }
            }
        }
        
        return Mesh(faces: faces)
    }
}

extension TerrainNode: GridPolyhedronProvider {
    
    var upperPolytope: Polytope {
        
        var corners: [Int] = [World.floor, World.floor, World.floor, World.floor]
        
        for edgeIndex in 0..<children.count {
            
            let nodeEdge = children[edgeIndex]
            
            let (c0, c1) = GridCorner.corners(edge: nodeEdge.edge)
            
            corners[c0.rawValue] = max(corners[c0.rawValue], nodeEdge.topLayer?.get(corner: c0) ?? World.floor)
            corners[c1.rawValue] = max(corners[c1.rawValue], nodeEdge.topLayer?.get(corner: c1) ?? World.floor)
        }
        
        return Polytope(x: MDWFloat(volume.coordinate.x), y0: corners[0], y1: corners[1], y2: corners[2], y3: corners[3], z: MDWFloat(volume.coordinate.z))
    }
    
    var lowerPolytope: Polytope {
        
        return Polytope(x: MDWFloat(volume.coordinate.x), y0: World.floor, y1: World.floor, y2: World.floor, y3: World.floor, z: MDWFloat(volume.coordinate.z))
    }
    
    public var polyhedron: Polyhedron { return Polyhedron(upperPolytope: upperPolytope, lowerPolytope: lowerPolytope) }
}

extension TerrainNode {
    
    public var totalChildren: Int { return children.count }
    
    public func child(at index: Int) -> SceneGraphChild? {
        
        guard (0 ..< totalChildren).contains(index) else { return nil }
        
        return children[index]
    }
    
    public func index(of child: SceneGraphChild) -> Int? {
        
        guard let child = child as? NodeEdge else { return nil }
        
        return children.index(of: child)
    }
}

extension TerrainNode {
    
    func add(edge: GridEdge) -> NodeEdge? {
        
        guard find(edge: edge) == nil else { return nil }
        
        let nodeEdge = NodeEdge(observer: self, volume: self.volume, edge: edge)
        
        children.append(nodeEdge)
        
        becomeDirty()
        
        return nodeEdge
    }
    
    public func find(edge: GridEdge) -> NodeEdge? {
        
        return children.first { $0.edge == edge }
    }
    
    @discardableResult func remove(edge: NodeEdge) -> Bool {
        
        if let index = children.index(of: edge) {
            
            children.remove(at: index)
            
            edge.observer = nil
            
            becomeDirty()
            
            return true
        }
        
        return false
    }
}

extension TerrainNode {
    
    public var filled: Bool {
        
        return totalChildren == 4
    }
    
    public var peak: Int {
        
        guard totalChildren > 0 else { return World.floor }
        
        return children.compactMap { $0.topLayer?.peak }.sorted { (lhs, rhs) -> Bool in
            
            return lhs > rhs
            
        }.first!
    }
}

extension TerrainNode: TerrainCutawayProvider {
    
    func add(cutaway: TerrainCutaway) -> Bool {
        
        let match = cutaways.first {
         
            switch $0.elevation(referencing: cutaway) {
             
            case .equal, .intersecting: return true
            default: return false
            }
        }
        
        if match == nil {
         
            cutaways.append(cutaway)
            
            becomeDirty()
            
            return true
        }
        
        return false
    }
    
    func remove(cutaway: TerrainCutaway) -> Bool {
        
        if let index = index(of: cutaway) {
            
            cutaways.remove(at: index)
            
            becomeDirty()
            
            return true
        }
        
        return false
    }
    
    func stencils(edge: GridEdge) -> [Polyhedron] {
        
        guard let nodeEdge = find(edge: edge) else { return [] }
        
        return Polyhedron.subtract(polyhedrons: cutaways, from: nodeEdge.polyhedron)
    }
}

extension TerrainNode: Walkable {
    
    public func pathNode(for edge: GridEdge) -> PathNode? {
        
        guard let terrainNodeEdge = find(edge: edge), let terrainNodeEdgeLayer = terrainNodeEdge.topLayer else { return nil }
        
        return PathNode(locus: (coordinate: volume.coordinate, edge: edge), position: terrainNodeEdgeLayer.upperPolytope.centroid(for: edge), movementCost: terrainNodeEdgeLayer.terrainType.movementCost)
    }
    
    public func neighbours(for edge: GridEdge) -> [PathNode]? {
        
        var pathNodes: [PathNode] = []
        
        GridEdge.inverse(edge: edge).forEach { inverseEdge in
            
            if let terrainNodeEdge = find(edge: inverseEdge), let terrainNodeEdgeLayer = terrainNodeEdge.topLayer {
                
                pathNodes.append(PathNode(locus: (coordinate: volume.coordinate, edge: inverseEdge), position: terrainNodeEdgeLayer.upperPolytope.centroid(for: inverseEdge), movementCost: terrainNodeEdgeLayer.terrainType.movementCost))
            }
        }
        
        let oppositeEdge = GridEdge.opposite(edge: edge)
        
        if let nodeNeighbour = find(neighbour: edge)?.node as? TerrainNode, let terrainNodeEdge = nodeNeighbour.find(edge: oppositeEdge), let terrainNodeEdgeLayer = terrainNodeEdge.topLayer {
            
            pathNodes.append(PathNode(locus: (coordinate: nodeNeighbour.volume.coordinate, edge: oppositeEdge), position: terrainNodeEdgeLayer.upperPolytope.centroid(for: oppositeEdge), movementCost: terrainNodeEdgeLayer.terrainType.movementCost))
        }
        
        return !pathNodes.isEmpty ? pathNodes : nil
    }
}
