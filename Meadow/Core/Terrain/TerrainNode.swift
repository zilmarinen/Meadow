//
//  TerrainNode.swift
//  Meadow
//
//  Created by Zack Brown on 27/04/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import SceneKit

public class TerrainNode<NodeEdge: TerrainNodeEdge<TerrainEdgeLayer>>: GridNode, SceneGraphParent {
    
    public typealias ChildType = NodeEdge
    
    public var children: [ChildType] = []
    
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
        
        children.forEach { edge in
            
            edge.clean()
        }
        
        isDirty = false
    }
    
    public override var mesh: Mesh {
        
        return Mesh(faces: [])
    }
}

extension TerrainNode {
    
    public func index(of child: ChildType) -> Int? {
        
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
        
        if let index = index(of: edge) {
            
            children.remove(at: index)
            
            edge.observer = nil
            
            becomeDirty()
            
            return true
        }
        
        return false
    }
}

extension TerrainNode: TerrainNodeIntersectionProvider {
    
    @discardableResult
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
    
    @discardableResult
    public func remove(intersection polyhedron: Polyhedron) -> Bool {
        
        if let index = intersections.index(of: polyhedron) {
            
            intersections.remove(at: index)
            
            becomeDirty()
            
            return true
        }
        
        return false
    }
}
