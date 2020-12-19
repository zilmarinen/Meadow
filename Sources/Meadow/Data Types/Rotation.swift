//
//  Rotation.swift
//
//  Created by Zack Brown on 16/12/2020.
//

import GLKit
import SceneKit

public struct Rotation: Hashable {
    
    public let quaternion: GLKQuaternion
}

public extension Rotation {
    
    static let identity = Rotation(quaternion: GLKQuaternionIdentity)
}

public extension Rotation {
    
    static func == (lhs: Rotation, rhs: Rotation) -> Bool {
        
        return lhs.quaternion.w == rhs.quaternion.w && lhs.quaternion.x == rhs.quaternion.x && lhs.quaternion.y == rhs.quaternion.y && lhs.quaternion.z == rhs.quaternion.z
    }
    
    func hash(into hasher: inout Hasher) {
        
        hasher.combine(self.quaternion.w)
        hasher.combine(self.quaternion.x)
        hasher.combine(self.quaternion.y)
        hasher.combine(self.quaternion.z)
    }
}

public extension Rotation {
    
    static func *(lhs: Rotation, rhs: Rotation) -> Rotation {
        
        return Rotation(quaternion: GLKQuaternionMultiply(lhs.quaternion, rhs.quaternion))
    }

    static func *=(lhs: inout Rotation, rhs: Rotation) {
        
        lhs = lhs * rhs
    }
}

public extension Rotation {
    
    static func pitch(radians: Double) -> Rotation {
        
        return Rotation(quaternion: GLKQuaternionMakeWithAngleAndVector3Axis(Float(radians), GLKVector3(vector: .x)))
    }
    
    static func roll(radians: Double) -> Rotation {
        
        return Rotation(quaternion: GLKQuaternionMakeWithAngleAndVector3Axis(Float(radians), GLKVector3(vector: .z)))
    }
    
    static func yaw(radians: Double) -> Rotation {
        
        return Rotation(quaternion: GLKQuaternionMakeWithAngleAndVector3Axis(Float(radians), GLKVector3(vector: .y)))
    }
    
    static func focus(eye: Vector, focus: Vector, up: Vector) -> GLKQuaternion {
        
        let worldUp = up.normalised()
        
        let forward = (eye - focus).normalised()
        
        let right = worldUp.cross(vector: forward).normalised()
        
        let localUp = forward.cross(vector: right).normalised()
        
        let m = GLKMatrix4Make(Float(right.x), Float(right.y), Float(right.z), 0.0,
                               Float(localUp.x), Float(localUp.y), Float(localUp.z), 0.0,
                               Float(forward.x), Float(forward.y), Float(forward.z), 0.0,
                               Float(eye.x), Float(eye.y), Float(eye.z), 1.0)
        
        return GLKQuaternionMakeWithMatrix4(m)
    }
}
