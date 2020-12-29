//
//  Vertex.swift
//
//  Created by Zack Brown on 03/11/2020.
//

import CoreGraphics

public struct Vertex: Hashable {
    
    let position: Vector
    let normal: Vector
    let color: Color
    let textureCoordinates: CGPoint
    
    public init(position: Vector, normal: Vector, color: Color = .black, textureCoordinates: CGPoint = .zero) {
        
        self.position = position.quantized()
        self.normal = normal.normalised()
        self.color = color
        self.textureCoordinates = textureCoordinates
    }
}

extension Vertex {
    
    public static func == (lhs: Vertex, rhs: Vertex) -> Bool {
        
        return lhs.position == rhs.position && lhs.normal == rhs.normal && lhs.color == rhs.color && lhs.textureCoordinates == rhs.textureCoordinates
    }
}

extension Vertex {
    
    func inverted() -> Vertex {
        
        return Vertex(position: position, normal: -normal, color: color, textureCoordinates: textureCoordinates)
    }
    
    func lerp(vertex: Vertex, interpolater: Double) -> Vertex {
        
        return Vertex(position: position.lerp(vector: vertex.position, interpolater: interpolater), normal: normal.lerp(vector: vertex.normal, interpolater: interpolater), color: color, textureCoordinates: textureCoordinates.lerp(point: vertex.textureCoordinates, interpolater: interpolater))
    }
}

extension Vertex: Transformable {
    
    public func translated(by translation: Vector) -> Vertex {
        
        return Vertex(position: position + translation, normal: normal, color: color, textureCoordinates: textureCoordinates)
    }
    
    public func rotated(by rotation: Rotation) -> Vertex {
        
        return Vertex(position: position.rotated(by: rotation), normal: normal.rotated(by: rotation), color: color, textureCoordinates: textureCoordinates)
    }
    
    public func scaled(by scale: Vector) -> Vertex {
        
        let scalar = Vector(x: 1 / scale.x, y: 1 / scale.y, z: 1 / scale.z)
        
        return Vertex(position: position.scaled(by: scale), normal: normal.scaled(by: scalar).normalised(), color: color, textureCoordinates: textureCoordinates)
    }
    
    public func transformed(by transform: Transform) -> Vertex {
        
        return scaled(by: transform.scale).rotated(by: transform.rotation).translated(by: transform.position)
    }
}
