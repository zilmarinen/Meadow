//
//  AreaNode.swift
//  Meadow
//
//  Created by Zack Brown on 01/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import SceneKit

public class AreaNode<NodeEdge: AreaNodeEdge>: GridNode, SceneGraphParent {
    
    var children = Tree<NodeEdge>()
    
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
        
        return Mesh(faces: [])
    }
}

extension AreaNode {
    
    public var totalChildren: Int { return children.count }
    
    public func child(at index: Int) -> SceneGraphChild? {
        
        return children[index]
    }
    
    public func index(of child: SceneGraphChild) -> Int? {
        
        guard let child = child as? NodeEdge else { return nil }
        
        return children.index(of: child)
    }
}
