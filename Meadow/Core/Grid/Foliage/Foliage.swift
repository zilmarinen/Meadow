//
//  Foliage.swift
//  Meadow
//
//  Created by Zack Brown on 07/02/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

public class Foliage: Grid<FoliageChunk, FoliageTile> {
    
    override init() {
        
        super.init()
        
        name = "Foliage"
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
}
