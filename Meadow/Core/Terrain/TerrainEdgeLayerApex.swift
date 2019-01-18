//
//  TerrainEdgeLayerApex.swift
//  Meadow
//
//  Created by Zack Brown on 16/01/2019.
//  Copyright © 2019 Script Orchard. All rights reserved.
//

class TerrainEdgeLayerApex: Encodable {
    
    enum Corner {
        
        case c0
        case c1
        case c2
    }
    
    let edge: GridEdge
    
    var c0 = World.floor
    var c1 = World.floor
    var c2 = World.floor
    
    init(edge: GridEdge) {
        
        self.edge = edge
    }
}

extension TerrainEdgeLayerApex {
    
    func get(height corner: Corner) -> Int {
        
        switch corner {
            
        case .c0: return self.c0
        case .c1: return self.c1
        case .c2: return self.c2
        }
    }
    
    func set(height: Int, corner: Corner) {
        
        switch corner {
            
        case .c0: self.c0 = height
        case .c1: self.c1 = height
        case .c2: self.c2 = height
        }
    }
}
