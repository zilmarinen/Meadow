//
//  TerrainLayer.swift
//  Meadow
//
//  Created by Zack Brown on 05/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

class TerrainLayer: GridChild {
    
    typealias ParentType = TerrainNode<TerrainLayer>
    
    var superNode: ParentType?
    
    var name: String? { return "" }
    
    var volume: Volume
    
    var isDirty: Bool = true
    
    init(superNode: ParentType, volume: Volume) {
        
        self.superNode = superNode
        
        self.volume = volume
    }
}

extension TerrainLayer: GridSoilable {
    
    func becomeDirty() {
        
        if !isDirty {
            
            isDirty = true
            
            superNode?.child(didBecomeDirty: self)
        }
    }
    
    func clean() {
        
        if !isDirty { return }
        
        //
        
        isDirty = false
    }
}

extension TerrainLayer: GridMeshProvider {
    
    var mesh: Int { return 0 }
}

extension TerrainLayer: Hashable {
    
    var hashValue: Int { return volume.hashValue }
    
    static func == (lhs: TerrainLayer, rhs: TerrainLayer) -> Bool {
        
        return lhs.volume == rhs.volume
    }
}

extension TerrainLayer: Encodable {
    
    enum CodingKeys: CodingKey {
        
        case name
        case volume
    }
    
    func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(self.name, forKey: .name)
        try container.encode(self.volume, forKey: .volume)
    }
}
