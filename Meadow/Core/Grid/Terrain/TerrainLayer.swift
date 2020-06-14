//
//  TerrainLayer.swift
//  Meadow
//
//  Created by Zack Brown on 07/02/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

public class TerrainLayer: Layer {
    
    public override var category: SceneGraphNodeCategory { return .terrain }
    
    public var terrainType: TerrainType = .bedrock {
        
        didSet {
            
            becomeDirty()
        }
    }
}
