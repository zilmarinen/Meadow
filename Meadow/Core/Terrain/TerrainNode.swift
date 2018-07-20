//
//  TerrainNode.swift
//  Meadow
//
//  Created by Zack Brown on 27/04/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

class TerrainNode<Layer: TerrainLayer>: GridNode, GridParent {
    
    typealias ChildType = Layer
    
    var totalChildren: Int { return children.count }
    
    var children: [Layer] = []
    
    enum CodingKeys: CodingKey {
        
        case layers
    }
    
    override func encode(to encoder: Encoder) throws {
        
        try super.encode(to: encoder)
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(self.children, forKey: .layers)
    }
    
    override func becomeDirty() -> Bool {
        
        if !isDirty {
            
            isDirty = true
        }
        
        return isDirty
    }
    
    override func clean() -> Bool {
        
        if !isDirty { return false }
        
        //
        
        isDirty = false
        
        return true
    }
    
    override var mesh: Int { return 0 }
}

extension TerrainNode {
    
    func child(at index: Int) -> SceneGraphChild? {
        
        return children[index]
    }
    
    func index(of child: SceneGraphChild) -> Int? {
        
        guard let child = child as? Layer else { return nil }
        
        return children.index(of: child)
    }
    
    func child(didBecomeDirty child: SceneGraphChild) {
        
        let _ = becomeDirty()
        
        superNode?.child(didBecomeDirty: child)
    }
}
