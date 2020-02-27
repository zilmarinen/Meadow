//
//  Water.swift
//  Meadow
//
//  Created by Zack Brown on 07/02/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

class Water: Grid<WaterChunk, WaterTile<WaterEdge>> {
    
    override init() {
        
        super.init()
        
        name = "Water"
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
}
