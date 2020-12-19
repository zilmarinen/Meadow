//
//  Color.swift
//
//  Created by Zack Brown on 03/11/2020.
//

import CoreGraphics

public struct Color: Codable, Hashable {
    
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
