//
//  Footpath.swift
//  Meadow
//
//  Created by Zack Brown on 07/02/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

class Footpath: Grid<FootpathChunk, FootpathTile<FootpathEdge>> {
    
    override init() {
        
        super.init()
        
        name = "Footpath"
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
}
