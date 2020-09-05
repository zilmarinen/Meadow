//
//  TerrainLayer.swift
//  Meadow
//
//  Created by Zack Brown on 07/02/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

public class TerrainLayer: Layer {
    
    enum CodingKeys: CodingKey {
        
        case terrainType
    }
    
    public override var category: SceneGraphNodeCategory { return .terrain }
    
    public var terrainType: TerrainType = .bedrock {
        
        didSet {
            
            guard oldValue != terrainType else { return }
            
            becomeDirty()
        }
    }
    
    public override func encode(to encoder: Encoder) throws {
        
        try super.encode(to: encoder)
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(terrainType, forKey: .terrainType)
    }
}
