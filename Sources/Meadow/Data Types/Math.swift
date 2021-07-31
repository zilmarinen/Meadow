//
//  Math.swift
//
//  Created by Zack Brown on 03/11/2020.
//

import Euclid
import Foundation
import GLKit

public enum Math {
    
    public static var epsilon = 1e-7
    public static var pi2 = .pi * 2.0
    
    public static func clamp<T: Comparable>(value: T, minimum: T, maximum: T) -> T {
        
        return min(max(value, minimum), maximum)
    }

    func curve(start: Vector, end: Vector, control: Vector, interpolator: Double) -> Vector {
        
        let ab = start.lerp(control, interpolator)
        let bc = control.lerp(end, interpolator)
        
        return ab.lerp(bc, interpolator)
    }
    
    public static func quantize(value: Double) -> Double {
        
        return (value / epsilon).rounded() * epsilon
    }
    
    public static func lerp(start: Double, end: Double, interpolator: Double) -> Double {
        
        return start + (abs(end - start) * interpolator)
    }
    
    public static func plot(radians: Double, radius: Double) -> Vector {
        
        return Vector(x: sin(radians) * radius, y: 0, z: cos(radians) * radius)
    }
}

extension Math {
    
    public enum Curve {
        
        case `in`
        case out
        case inOut
    }
    
    public static func ease(curve: Curve, value: Double) -> Double {
        
        switch curve {
            
        case .in: return value * value
        case .out: return 1.0 - ease(curve: .in, value: 1.0 - value)
        case .inOut: return Math.lerp(start: ease(curve: .in, value: value), end: ease(curve: .out, value: value), interpolator: value)
        }
    }
    
    public static func smoothStep(value: Double, minimum: Double, maximum: Double) -> Double {
        
        let result = Math.clamp(value: (value - minimum) / (maximum - minimum), minimum: 0.0, maximum: 1.0)
        
        return result * result * (3 - 2 * result)
    }
    
    public static func smootherStep(value: Double, minimum: Double, maximum: Double) -> Double {
        
        let result = Math.clamp(value: (value - minimum) / (maximum - minimum), minimum: 0.0, maximum: 1.0)
        
        return result * result * result * (result * (result * 6 - 15) + 10)
    }
}

extension Math {
    
    public static func random(minimum: Double, maximum: Double) -> Double {
        
        return Double.random(in: minimum...maximum)
    }
}

extension Math {
    
    public static func radians(degrees: Double) -> Double {
        
        return Double(GLKMathDegreesToRadians(Float(degrees)))
    }
    
    public static func degrees(radians: Double) -> Double {
        
        return Double(GLKMathRadiansToDegrees(Float(radians)))
    }
}
