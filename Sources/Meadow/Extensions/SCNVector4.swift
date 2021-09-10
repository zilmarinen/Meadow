//
//  SCNVector4.swift
//
//  Created by Zack Brown on 03/11/2020.
//

import Euclid
import SceneKit

extension SCNVector4: Codable {
    
    private enum CodingKeys: CodingKey {
     
        case w
        case x
        case y
        case z
    }
    
    public init(color: Color) {
        
        self.init(color.r, color.g, color.b, color.a)
    }
    
    public init(from decoder: Decoder) throws {
        
        self.init()
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.w = try container.decode(MDWFloat.self, forKey: .w)
        self.x = try container.decode(MDWFloat.self, forKey: .x)
        self.y = try container.decode(MDWFloat.self, forKey: .y)
        self.z = try container.decode(MDWFloat.self, forKey: .z)
    }
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(w, forKey: .w)
        try container.encode(x, forKey: .x)
        try container.encode(y, forKey: .y)
        try container.encode(z, forKey: .z)
    }
}
