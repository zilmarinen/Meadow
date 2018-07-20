//
//  Color.swift
//  Meadow
//
//  Created by Zack Brown on 09/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import SceneKit

public struct Color: Codable {
    
    public let red: MDWFloat
    public let green: MDWFloat
    public let blue: MDWFloat
    public let alpha: MDWFloat
    
    public var color: MDWColor {
        
        return MDWColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    public var vector: SCNVector4 {
        
        return SCNVector4(x: red, y: green, z: blue, w: alpha)
    }
}
