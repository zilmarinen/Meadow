//
//  Math.swift
//
//  Created by Zack Brown on 03/11/2020.
//

import Foundation
import GLKit

enum Math {
    
    static var epsilon = 1e-7
    static var pi2 = .pi * 2.0
    
    static func quantize(value: Double) -> Double {
        
        return (value / epsilon).rounded() * epsilon
    }
    
    static func radians(degrees: Float) -> Double {
        
        return Double(GLKMathDegreesToRadians(degrees))
    }
    
    static func degrees(radians: Float) -> Double {
        
        return Double(GLKMathRadiansToDegrees(radians))
    }
}
