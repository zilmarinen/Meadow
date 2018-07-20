//
//  GridChunk.swift
//  Meadow
//
//  Created by Zack Brown on 26/04/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import SceneKit

class GridChunk<Tile: GridTile<Node>, Node: GridNode>: SCNNode, GridChild, GridParent {
    
    typealias ParentType = Grid<GridChunk, Tile, Node>
    typealias ChildType = Tile
    
    var superNode: ParentType?
    
    var totalChildren: Int { return children.count }
    
    var children: [Tile] = []
    
    let volume: Volume
    
    var isDirty: Bool = true
    
    init(superNode: ParentType, volume: Volume) {
        
        self.superNode = superNode
        
        self.volume = volume
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
}

extension GridChunk: GridSoilable {
    
    func becomeDirty() {
        
        if !isDirty {
            
            isDirty = true
        }
    }
    
    func clean() {
        
        if !isDirty { return }
        
        children.forEach { tile in
            
            tile.clean()
        }
        
        isDirty = false
    }
}

extension GridChunk: GridUpdatable {
    
    func update(deltaTime: TimeInterval) {
        
        clean()
        
        children.forEach { tile in
            
            tile.update(deltaTime: deltaTime)
        }
    }
}

extension GridChunk {
    
    func child(at index: Int) -> SceneGraphChild? {
        
        return childNodes[index] as? SceneGraphChild
    }
    
    func index(of child: SceneGraphChild) -> Int? {
        
        guard let child = child as? SCNNode else { return nil }
        
        return childNodes.index(of: child)
    }
    
    func child(didBecomeDirty child: SceneGraphChild) {
        
        let _ = becomeDirty()
        
        superNode?.child(didBecomeDirty: child)
    }
}

extension GridChunk {
    
    func add(tile coordinate: Int) -> Tile? {
        
        return nil
    }
    
    func find(tile coordinate: Int) -> Tile? {
        
        return nil
    }
    
    func remove(tile coordinate: Int) -> Tile? {
        
        return nil
    }
}

extension GridChunk: Encodable {
    
    enum CodingKeys: CodingKey {
        
        case name
        case volume
        case children
    }
    
    func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(self.name, forKey: .name)
        try container.encode(self.volume, forKey: .volume)
        try container.encode(self.children, forKey: .children)
    }
}
