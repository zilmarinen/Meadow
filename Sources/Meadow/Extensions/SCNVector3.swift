//
//  SCNVector3.swift
//
//  Created by Zack Brown on 03/11/2020.
//

import SceneKit

extension SCNVector3: Codable {
    
    private enum CodingKeys: CodingKey {
     
        case x
        case y
        case z
    }
    
    init(vector: Vector) {
        
        self.init(vector.x, vector.y, vector.z)
    }
    
    init(coordinate: Coordinate) {
        
        self.init(coordinate.x, coordinate.y, coordinate.z)
    }
    
    public init(from decoder: Decoder) throws {
        
        self.init()
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.x = try container.decode(CGFloat.self, forKey: .x)
        self.y = try container.decode(CGFloat.self, forKey: .y)
        self.z = try container.decode(CGFloat.self, forKey: .z)
    }
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(x, forKey: .x)
        try container.encode(y, forKey: .y)
        try container.encode(z, forKey: .z)
    }
}

extension SCNVector3 {

    static var zero = SCNVector3(x: 0, y: 0, z: 0)
    static var left = SCNVector3(x: 1, y: 0, z: 0)
    static var right = SCNVector3(x: -1, y: 0, z: 0)
    static var forward = SCNVector3(x: 0, y: 0, z: 1)
    static var backward = SCNVector3(x: 0, y: 0, z: -1)
    static var up = SCNVector3(x: 0, y: 1, z: 0)
    static var down = SCNVector3(x: 0, y: -1, z: 0)
}
