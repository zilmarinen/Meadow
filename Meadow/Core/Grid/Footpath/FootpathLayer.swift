//
//  FootpathLayer.swift
//  Meadow
//
//  Created by Zack Brown on 07/02/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

public class FootpathLayer: Layer {
    
    enum CodingKeys: CodingKey {
        
        case footpathType
    }
    
    public override var category: SceneGraphNodeCategory { return .footpath }
    
    public var footpathType: FootpathType = .dirt {
        
        didSet {
            
            guard oldValue != footpathType else { return }
            
            becomeDirty()
        }
    }
    
    public override func encode(to encoder: Encoder) throws {
        
        try super.encode(to: encoder)
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(footpathType, forKey: .footpathType)
    }
}
