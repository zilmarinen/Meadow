//
//  SCNVector4.swift
//  Meadow
//
//  Created by Zack Brown on 08/06/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import SceneKit

extension SCNVector4: Codable {
    
    enum CodingKeys: CodingKey {
        
        case x
        case y
        case z
        case w
    }
    
    public init(from decoder: Decoder) throws {
        
        self.init()
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.x = try container.decode(MDWFloat.self, forKey: .x)
        self.y = try container.decode(MDWFloat.self, forKey: .y)
        self.z = try container.decode(MDWFloat.self, forKey: .z)
        self.w = try container.decode(MDWFloat.self, forKey: .w)
    }
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(self.x, forKey: .x)
        try container.encode(self.y, forKey: .y)
        try container.encode(self.z, forKey: .z)
        try container.encode(self.w, forKey: .w)
    }
}


extension SCNVector4 {
    
    public static func ==(lhs: SCNVector4, rhs: SCNVector4) -> Bool {
        
        return lhs.x == rhs.x && lhs.y == rhs.y && lhs.z == rhs.z && lhs.w == rhs.w
    }
    
    public static func length(vector: SCNVector4) -> MDWFloat {
        
        let v = GLKVector4Make(Float(vector.x), Float(vector.y), Float(vector.z), Float(vector.w))
        
        return MDWFloat(GLKVector4Length(v))
    }

    public static func normalise(vector: SCNVector4) -> SCNVector4 {
        
        let v = GLKVector4Make(Float(vector.x), Float(vector.y), Float(vector.z), Float(vector.w))
        
        let n = GLKVector4Normalize(v)
        
        return SCNVector4(x: MDWFloat(n.x), y: MDWFloat(n.y), z: MDWFloat(n.z), w: MDWFloat(n.w))
    }
}
