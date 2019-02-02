//
//  TerrainNode.swift
//  Meadow
//
//  Created by Zack Brown on 27/04/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import SceneKit

public class TerrainNode<NodeEdge: TerrainNodeEdge<TerrainEdgeLayer>>: GridNode, SceneGraphParent {
    
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
    
    public override func clean() {
        
        if !isDirty { return }
        
        children.forEach { edge in
            
            edge.clean()
        }
        
        isDirty = false
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
                            
                            faces.append(contentsOf: MeshFace.edge(crown: (c0: c0, c1: c1), polyhedron: stencil, normal: edgeNormal, color: colorPalette.primary.vector))
                            faces.append(contentsOf: MeshFace.edge(throne: (c0: c0, c1: c1), polyhedron: stencil, normal: edgeNormal, color: colorPalette.secondary.vector))
                        }
                        else {
                            
                            faces.append(contentsOf: MeshFace.edge(corners: (c0: c0, c1: c1), polyhedron: stencil, normal: edgeNormal, color: colorPalette.secondary.vector))
                        }
                    }
                    
                    let (e0, e1) = GridEdge.edges(edge: nodeEdge.edge)
                    
                    [e0, e1].forEach { edge in
                    
                        let (c2, c3) = GridCorner.corners(edge: edge)
                        
                        let corner = (c2 == c0 ? c2 : (c2 == c1 ? c2 : c3))
                        
                        if layer.upper == nil || layer.upper?.lowerPolytope != polyhedron.upperPolytope {
                            
                            faces.append(contentsOf: MeshFace.diagonal(crown: corner, polyhedron: polyhedron, normal: inverseNormal, color: colorPalette.primary.vector))
                            faces.append(contentsOf: MeshFace.diagonal(throne: corner, polyhedron: polyhedron, normal: inverseNormal, color: colorPalette.secondary.vector))
                        }
                        else {
                            
                            faces.append(contentsOf: MeshFace.diagonal(corner: corner, polyhedron: polyhedron, normal: inverseNormal, color: colorPalette.secondary.vector))
                        }
                    }
                }
            }
        }
        
        return Mesh(faces: faces)
    }
}

extension TerrainNode {
    
    public var totalChildren: Int { return children.count }
    
    public func child(at index: Int) -> SceneGraphChild? {
        
        return children[index]
    }
    
    public func index(of child: SceneGraphChild) -> Int? {
        
        guard let child = child as? NodeEdge else { return nil }
        
        return children.index(of: child)
    }
}

extension TerrainNode {
    
    func add(edge: GridEdge) -> NodeEdge? {
        
        if find(edge: edge) != nil {
            
            return nil
        }
        
        let nodeEdge = NodeEdge(observer: self, volume: self.volume, edge: edge)
        
        children.append(nodeEdge)
        
        becomeDirty()
        
        return nodeEdge
    }
    
    public func find(edge: GridEdge) -> NodeEdge? {
        
        return children.first { $0.edge == edge }
    }
    
    @discardableResult
    func remove(edge: NodeEdge) -> Bool {
        
        if let index = children.index(of: edge) {
            
            children.remove(at: index)
            
            edge.observer = nil
            
            becomeDirty()
            
            return true
        }
        
        return false
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
