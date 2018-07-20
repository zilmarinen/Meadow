//
//  Grid.swift
//  Meadow
//
//  Created by Zack Brown on 26/04/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import SceneKit

class Grid<Chunk: GridChunk<Tile, Node>, Tile: GridTile<Node>, Node: GridNode>: SCNNode, SceneGraphChild, GridParent {
    
    typealias ChildType = Chunk
    
    var totalChildren: Int { return childNodes.count }
    
    var children: [Chunk] { return childNodes as! [Chunk] }
    
    var isDirty: Bool = true
    
    var observer: GridObserver?
}

extension Grid: GridSoilable {
    
    func becomeDirty() -> Bool {
        
        if !isDirty {
            
            isDirty = true
        }
        
        return isDirty
    }
    
    func clean() -> Bool {
        
        if !isDirty { return false }
        
        //
        
        isDirty = false
        
        return true
    }
}

extension Grid {
    
    func child(at index: Int) -> SceneGraphChild? {
        
        return childNodes[index] as? SceneGraphChild
    }
    
    func index(of child: SceneGraphChild) -> Int? {
        
        guard let child = child as? SCNNode else { return nil }
        
        return childNodes.index(of: child)
    }
    
    func child(didBecomeDirty child: SceneGraphChild) {
        
        let _ = becomeDirty()
        
        observer?.child(didBecomeDirty: child)
    }
}

extension Grid {
    
    func add(node coordinate: Int) -> Node? {
        
        return nil
    }
    
    func find(chunk coordinate: Int) -> Chunk? {
        
        return nil
    }
    
    func find(tile coordinate: Int) -> Tile? {
        
        return nil
    }
    
    func find(node coordinate: Int) -> Node? {
        
        return nil
    }
    
    func remove(chunk coordinate: Int) -> Chunk? {
        
        return nil
    }
    
    func remove(tile coordinate: Int) -> Tile? {
        
        return nil
    }
    
    func remove(node coordinate: Int) -> Node? {
        
        return nil
    }
}

extension Grid: Encodable {
    
    enum CodingKeys: CodingKey {
        
        case name
        case children
    }
    
    func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(self.name, forKey: .name)
        try container.encode(self.children, forKey: .children)
    }
}
