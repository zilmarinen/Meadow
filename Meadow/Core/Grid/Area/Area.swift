//
//  Area.swift
//  Meadow
//
//  Created by Zack Brown on 07/02/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

class Area: Grid<AreaChunk, AreaTile<AreaEdge>> {
    
    override init() {
        
        super.init()
        
        name = "Area"
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
}
