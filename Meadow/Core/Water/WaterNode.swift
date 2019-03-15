//
//  WaterNode.swift
//  Meadow
//
//  Created by Zack Brown on 01/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import SceneKit

public class WaterNode<NodeEdge: WaterNodeEdge>: GridNode, SceneGraphParent {
    
    var children = Tree<NodeEdge>()
    
    var basePolytope: Polytope? {
        
        didSet {
            
            if basePolytope != oldValue {
                
                becomeDirty()
            }
        }
    }
    
    enum CodingKeys: CodingKey {
        
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
            
            guard let colorPalette = nodeEdge.waterType.colorPalette, !nodeEdge.isHidden else { continue }
            
            let (c0, c1) = GridCorner.corners(edge: nodeEdge.edge)
            
            let edgeNormal = GridEdge.normal(edge: nodeEdge.edge)
            let inverseNormal = SCNVector3.negate(vector: edgeNormal)
            
            let neighbourNode = find(neighbour: nodeEdge.edge)?.node as? WaterNode
            
            let neighbourEdge = neighbourNode?.find(edge: GridEdge.opposite(edge: nodeEdge.edge))
            
            faces.append(MeshFace.apex(corners: (c0: c0, c1: c1), polytope: nodeEdge.upperPolytope, color: colorPalette.primary.vector))
            
            if let neighbourEdge = neighbourEdge, nodeEdge.waterLevel > neighbourEdge.waterLevel {
                
                let lowerPolytope = Polytope.translate(polytope: neighbourEdge.upperPolytope, translation: inverseNormal)
                
                let polyhedron = Polyhedron(upperPolytope: nodeEdge.upperPolytope, lowerPolytope: lowerPolytope)
                
                faces.append(contentsOf: MeshFace.edge(corners: (c0: c0, c1: c1), polyhedron: polyhedron, normal: edgeNormal, color: colorPalette.secondary.vector))
            }
            else if neighbourEdge == nil {
                
                faces.append(contentsOf: MeshFace.edge(corners: (c0: c0, c1: c1), polyhedron: nodeEdge.polyhedron, normal: edgeNormal, color: colorPalette.secondary.vector))
            }
            
            let (e0, e1) = GridEdge.edges(edge: nodeEdge.edge)
            
            [e0, e1].forEach { edge in
                
                let diagonalNormal = inverseNormal + GridEdge.normal(edge: edge)
                
                let (c2, c3) = GridCorner.corners(edge: edge)
                
                let corner = (c2 == c0 ? c2 : (c2 == c1 ? c2 : c3))
                
                let cornerUpper = nodeEdge.upperPolytope.vertices[corner.rawValue]
                let centreUpper = nodeEdge.upperPolytope.center
                
                var cornerLower = nodeEdge.lowerPolytope.vertices[corner.rawValue]
                var centerLower = nodeEdge.lowerPolytope.center
                
                let connectedEdge = find(edge: edge)
                
                if let connectedEdge = connectedEdge, nodeEdge.waterLevel > connectedEdge.waterLevel {
                    
                    cornerLower = connectedEdge.upperPolytope.vertices[corner.rawValue]
                    centerLower = connectedEdge.upperPolytope.center
                    
                    let polytope = Polytope(v0: cornerUpper, v1: centreUpper, v2: centerLower, v3: cornerLower)
                    
                    faces.append(contentsOf: MeshFace.diagonal(polytope: polytope, normal: diagonalNormal, color: colorPalette.secondary.vector))
                }
                else if connectedEdge == nil {
                    
                    let polytope = Polytope(v0: cornerUpper, v1: centreUpper, v2: centerLower, v3: cornerLower)
                    
                    faces.append(contentsOf: MeshFace.diagonal(polytope: polytope, normal: diagonalNormal, color: colorPalette.secondary.vector))
                }
            }
        }
        
        return Mesh(faces: faces)
    }
}

extension WaterNode {
    
    public var totalChildren: Int { return children.count }
    
    public func child(at index: Int) -> SceneGraphChild? {
        
        return children[index]
    }
    
    public func index(of child: SceneGraphChild) -> Int? {
        
        guard let child = child as? NodeEdge else { return nil }
        
        return children.index(of: child)
    }
}

extension WaterNode {
    
    func add(edge: GridEdge, waterType: WaterType) -> NodeEdge? {
        
        guard find(edge: edge) == nil else { return nil }
        
        let nodeEdge = NodeEdge(observer: self, volume: self.volume, edge: edge, waterType: waterType)
        
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

extension WaterNode {
    
    var waterTablePeak: WaterNodeEdge? {
        
        return children.sorted { (lhs, rhs) -> Bool in
            
            return lhs.waterLevel > rhs.waterLevel
            
        }.first
    }
}
