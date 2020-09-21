//
//  FoliageTile.swift
//  Meadow
//
//  Created by Zack Brown on 07/02/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

public class FoliageTile: Tile {
    
    enum CodingKeys: CodingKey {
        
        case foliageType
    }
    
    public override var category: SceneGraphNodeCategory { return .foliage }
    
    public var foliageType: FoliageType = .fir {
        
        didSet {
            
            guard oldValue != foliageType else { return }
            
            becomeDirty()
        }
    }
    
    public override func encode(to encoder: Encoder) throws {
        
        try super.encode(to: encoder)
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(foliageType, forKey: .foliageType)
    }
}
