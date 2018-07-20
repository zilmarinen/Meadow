//
//  GridTile.swift
//  Meadow
//
//  Created by Zack Brown on 26/04/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

class GridTile<Node: GridNode>: GridChild, GridParent {
    
    typealias ParentType = GridChunk<GridTile, Node>
    typealias ChildType = Node
    
    var superNode: ParentType?
    
    var totalChildren: Int { return children.count }
    
    var children: [Node] = []
    
    var name: String? { return "" }
    
    let volume: Int
    
    var isDirty: Bool = true
    
    init(superNode: ParentType, volume: Int) {
        
        self.superNode = superNode
        
        self.volume = volume
    }
}

extension GridTile: GridSoilable {
    
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

extension GridTile: GridMeshProvider {
    
    var mesh: Int { return 0 }
}

extension GridTile {
    
    func child(at index: Int) -> SceneGraphChild? {
        
        return children[index]
    }
    
    func index(of child: SceneGraphChild) -> Int? {
        
        guard let child = child as? Node else { return nil }
        
        return children.index(of: child)
    }
    
    func child(didBecomeDirty child: SceneGraphChild) {
        
        let _ = becomeDirty()
        
        superNode?.child(didBecomeDirty: child)
    }
}

extension GridTile {
    
    func add(node coordinate: Int) -> Node? {
        
        return nil
    }
    
    func find(node coordinate: Int) -> Node? {
        
        return nil
    }
    
    func remove(node coordinate: Int) -> Node? {
        
        return nil
    }
}

extension GridTile: Hashable {
    
    var hashValue: Int { return volume }
    
    static func == (lhs: GridTile, rhs: GridTile) -> Bool {
        
        return lhs.volume == rhs.volume
    }
}

extension GridTile: Encodable {
    
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
