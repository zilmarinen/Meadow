//
//  Color.swift
//  Meadow
//
//  Created by Zack Brown on 20/05/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

import SceneKit

public struct Color: Codable, Hashable {
    
    public let name: String
    
    public let red: Float
    public let green: Float
    public let blue: Float
    public let alpha: Float
    
    public init(name: String? = nil, red: Float, green: Float, blue: Float, alpha: Float = 1.0) {
        
        self.name = name ?? "[\(red), \(green), \(blue), \(alpha)]"
        self.red = red
        self.green = green
        self.blue = blue
        self.alpha = alpha
    }
    
    public init(color: MDWColor) {
        
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        self.name = "[\(red), \(green), \(blue), \(alpha)]"
        self.red = Float(red)
        self.green = Float(green)
        self.blue = Float(blue)
        self.alpha = Float(alpha)
    }
    
    public var color: MDWColor {
        
        return MDWColor(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: CGFloat(alpha))
    }
    
    public var vector: SCNVector4 {
        
        return SCNVector4(x: MDWFloat(red), y: MDWFloat(green), z: MDWFloat(blue), w: MDWFloat(alpha))
    }
    
    public var uniform: vector_float4 {
        
        return vector_float4(x: red, y: green, z: blue, w: alpha)
    }
}

extension Color {
    
    public static var black = Color(red: 0, green: 0, blue: 0)
    public static var white = Color(red: 1, green: 1, blue: 1)
}
