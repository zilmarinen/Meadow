//
//  TerrainNode.swift
//  Meadow
//
//  Created by Zack Brown on 27/04/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

public class TerrainNode<Layer: TerrainLayer>: GridNode, GridParent {
    
    public typealias ChildType = Layer
    
    public var totalChildren: Int { return children.count }
    
    public var children: [Layer] = []
    
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
    
    public override var mesh: Mesh { return Mesh(faces: []) }
}

extension TerrainNode {
    
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
    
    public func add(layer: TerrainType) -> TerrainLayer? {
        
        return nil
    }
    
    public func remove(layer: TerrainLayer) -> Bool {
        
        if let index = index(of: layer) {
        
            children.remove(at: index)
            
            return true
        }
        
        return false
    }
}
