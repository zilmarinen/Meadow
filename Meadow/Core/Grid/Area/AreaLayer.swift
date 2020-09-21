//
//  AreaLayer.swift
//  Meadow
//
//  Created by Zack Brown on 07/02/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

public class AreaLayer: Layer {
    
    enum CodingKeys: CodingKey {
        
        case areaType
    }
    
    public override var category: SceneGraphNodeCategory { return .area }
    
    public var areaType: AreaType = .brick {
        
        didSet {
            
            guard oldValue != areaType else { return }
            
            becomeDirty()
        }
    }
    
    public override func encode(to encoder: Encoder) throws {
        
        try super.encode(to: encoder)
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(areaType, forKey: .areaType)
    }
}
