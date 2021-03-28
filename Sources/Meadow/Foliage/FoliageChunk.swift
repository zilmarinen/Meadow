//
//  FoliageChunk.swift
//
//  Created by Zack Brown on 27/03/2021.
//

import SceneKit

class FoliageChunk: NonUniformChunk {
    
    private enum CodingKeys: CodingKey {
        
        case foliageType
        case foliageSize
    }
    
    var foliageType: FoliageType = .tree {
        
        didSet {
            
            if oldValue != foliageType {
                
                becomeDirty()
            }
        }
    }
    
    var foliageSize: FoliageSize = .small {
        
        didSet {
            
            if oldValue != foliageSize {
                
                becomeDirty()
            }
        }
    }
    
    required public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        foliageType = try container.decode(FoliageType.self, forKey: .foliageType)
        foliageSize = try container.decode(FoliageSize.self, forKey: .foliageSize)
        
        try super.init(from: decoder)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func encode(to encoder: Encoder) throws {
        
        try super.encode(to: encoder)
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(foliageType, forKey: .foliageType)
        try container.encode(foliageSize, forKey: .foliageSize)
    }
    
    override func clean() -> Bool {
        
        guard super.clean() else { return false }
        
        switch foliageType {
        
        case .bush: self.geometry?.firstMaterial?.diffuse.contents = MDWColor.systemTeal
        case .flower: self.geometry?.firstMaterial?.diffuse.contents = MDWColor.systemOrange
        default: self.geometry?.firstMaterial?.diffuse.contents = MDWColor.systemGreen
        }
        
        return true
    }
}
