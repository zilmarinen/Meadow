//
//  Color.swift
//
//  Created by Zack Brown on 03/11/2020.
//

import CoreGraphics

public struct Color: Codable, Hashable {
    
    private enum CodingKeys: String, CodingKey {
        
        case red = "r"
        case green = "g"
        case blue = "b"
        case alpha = "a"
    }
    
    public let red: Double
    public let green: Double
    public let blue: Double
    public let alpha: Double
    
    public init(red: Double, green: Double, blue: Double, alpha: Double = 1.0) {
    
        self.red = red
        self.green = green
        self.blue = blue
        self.alpha = alpha
    }
    
    public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        red = try container.decode(Double.self, forKey: .red)
        green = try container.decode(Double.self, forKey: .green)
        blue = try container.decode(Double.self, forKey: .blue)
        alpha = try container.decode(Double.self, forKey: .alpha)
    }
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(red, forKey: .red)
        try container.encode(green, forKey: .green)
        try container.encode(blue, forKey: .blue)
        try container.encode(alpha, forKey: .alpha)
    }
}

extension Color {
    
    public var color: MDWColor {
        
        #if os(macOS)
        
            return MDWColor(calibratedRed: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: CGFloat(alpha))

        #else

            return MDWColor(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: CGFloat(alpha))

        #endif
    }
}

public extension Color {
    
    static var black = Color(red: 0, green: 0, blue: 0)
    static var white = Color(red: 1, green: 1, blue: 1)
    static var red = Color(red: 1, green: 0, blue: 0)
    static var green = Color(red: 0, green: 1, blue: 0)
    static var blue = Color(red: 0, green: 0, blue: 1)
}
