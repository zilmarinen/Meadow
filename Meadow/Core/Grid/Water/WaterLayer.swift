//
//  WaterLayer.swift
//  Meadow
//
//  Created by Zack Brown on 07/02/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

public class WaterLayer: Layer {
    
    enum CodingKeys: CodingKey {
        
        case waterType
    }
    
    public override var category: SceneGraphNodeCategory { return .water }
    
    public var waterType: WaterType = .saltWater {
        
        didSet {
            
            becomeDirty()
        }
    }
    
    public override func encode(to encoder: Encoder) throws {
        
        try super.encode(to: encoder)
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(waterType, forKey: .waterType)
    }
}
