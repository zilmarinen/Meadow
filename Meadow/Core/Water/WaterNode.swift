//
//  WaterNode.swift
//  Meadow
//
//  Created by Zack Brown on 01/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import SceneKit

public class WaterNode: GridNode {
    
    public var waterType: WaterType? {
        
        didSet {
            
            if waterType != oldValue {
                
                becomeDirty()
            }
        }
    }
    
    public var waterLevel: Int = World.floor {
        
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
    
    public override var mesh: Mesh {
        
        return Mesh(faces: [])
    }
}

extension WaterNode: GridPolyhedronProvider {
    
    var upperPolytope: Polytope {
        
        return Polytope(x: MDWFloat(volume.coordinate.x), y0: waterLevel, y1: waterLevel, y2: waterLevel, y3: waterLevel, z: MDWFloat(volume.coordinate.z))
    }
    
    var lowerPolytope: Polytope {
        
        return basePolytope ?? Polytope(x: MDWFloat(volume.coordinate.x), y0: World.floor, y1: World.floor, y2: World.floor, y3: World.floor, z: MDWFloat(volume.coordinate.z))
    }
    
    public var polyhedron: Polyhedron { return Polyhedron(upperPolytope: upperPolytope, lowerPolytope: lowerPolytope) }
}

extension WaterNode {
    
    static let meniscus: MDWFloat = 0.05
    static let tension: MDWFloat = 0.01
}
