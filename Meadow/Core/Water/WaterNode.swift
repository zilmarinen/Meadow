//
//  WaterNode.swift
//  Meadow
//
//  Created by Zack Brown on 01/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

public class WaterNode: GridNode {
    
    var waterLevel: Int = World.floor {
        
        didSet {
            
            if waterLevel != oldValue {
                
                becomeDirty()
            }
        }
    }
    
    var basePolytope: Polytope? {
        
        didSet {
            
            if basePolytope != oldValue {
                
                becomeDirty()
            }
        }
    }
    
    var waterType: WaterType? {
        
        didSet {
            
            if waterType != oldValue {
                
                becomeDirty()
            }
        }
    }
    
    enum CodingKeys: CodingKey {
        
        case waterLevel
        case waterType
    }
    
    public override func encode(to encoder: Encoder) throws {
        
        try super.encode(to: encoder)
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(self.waterLevel, forKey: .waterLevel)
        try container.encode(self.waterType, forKey: .waterType)
    }
}

extension WaterNode: GridPolyhedronProvider {
    
    var upperPolytope: Polytope {
        
        return Polytope(x: MDWFloat(volume.coordinate.x), corners: [waterLevel, waterLevel, waterLevel, waterLevel], z: MDWFloat(volume.coordinate.z))!
    }
    
    var lowerPolytope: Polytope {
        
        return basePolytope ?? Polytope(x: MDWFloat(volume.coordinate.x), corners: [World.floor, World.floor, World.floor, World.floor], z: MDWFloat(volume.coordinate.z))!
    }
    
    public var polyhedron: Polyhedron { return Polyhedron(upperPolytope: upperPolytope, lowerPolytope: lowerPolytope) }
}
