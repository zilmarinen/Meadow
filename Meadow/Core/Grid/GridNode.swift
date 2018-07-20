//
//  GridNode.swift
//  Meadow
//
//  Created by Zack Brown on 26/04/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

class GridNode: GridChild, GridMeshProvider, GridSoilable, Encodable {
    
    typealias ParentType = GridTile<GridNode>
    
    var superNode: ParentType?
    
    var name: String? { return "" }
    
    let volume: Int
    
    var isDirty: Bool = true
    
    private enum CodingKeys: CodingKey {
        
        case name
        case volume
    }
    
    func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(self.name, forKey: .name)
        try container.encode(self.volume, forKey: .volume)
    }
    
    init(superNode: ParentType, volume: Int) {
        
        self.superNode = superNode
        
        self.volume = volume
    }
    
    func becomeDirty() -> Bool {
        
        if !isDirty {
            
            isDirty = true
            
            superNode?.child(didBecomeDirty: self)
        }
        
        return isDirty
    }
    
    func clean() -> Bool {
        
        return false
    }
    
    var mesh: Int { return 0 }
}

extension GridNode: Hashable {
    
    var hashValue: Int { return volume }
    
    static func == (lhs: GridNode, rhs: GridNode) -> Bool {
        
        return lhs.volume == rhs.volume
    }
}
