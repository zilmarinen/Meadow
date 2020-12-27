//
//  Transform.swift
//
//  Created by Zack Brown on 23/12/2020.
//

public class Transform: Hashable {
    
    public var position: Vector
    public var rotation: Rotation
    public var scale: Vector
    
    public init(position: Vector = .zero, rotation: Rotation = .identity, scale: Vector = .one) {
        
        self.position = position
        self.rotation = rotation
        self.scale = scale
    }
}

public extension Transform {
    
    static func == (lhs: Transform, rhs: Transform) -> Bool {
        
        return lhs.position == rhs.position && lhs.rotation == rhs.rotation && lhs.scale == rhs.scale
    }
    
    func hash(into hasher: inout Hasher) {
        
        hasher.combine(position)
        hasher.combine(rotation)
        hasher.combine(scale)
    }
}

public extension Transform {
    
    static let identity = Transform()
}

extension Transform {
    
    func translate(by translation: Vector) {
        
        self.position = self.position + translation.scaled(by: scale).rotated(by: rotation)
    }
    
    func rotate(by rotation: Rotation) {
        
        self.rotation *= rotation
    }
    
    func scale(by scale: Vector) {
        
        self.scale = self.scale.scaled(by: scale)
    }
}
