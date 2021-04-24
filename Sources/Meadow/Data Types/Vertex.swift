//
//  Vertex.swift
//
//  Created by Zack Brown on 03/11/2020.
//

import CoreGraphics

public struct Vertex: Codable, Hashable {
    
    private enum CodingKeys: String, CodingKey {
        
        case position = "p"
        case normal = "n"
        case color = "c"
        case textureCoordinates = "uv"
    }
    
    let position: Vector
    let normal: Vector
    let color: Color
    let textureCoordinates: Vector
    
    public init(position: Vector, normal: Vector, color: Color = .black, textureCoordinates: Vector = .zero) {
        
        self.position = position.quantized()
        self.normal = normal.normalised()
        self.color = color
        self.textureCoordinates = textureCoordinates
    }
    
    public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        position = try container.decode(Vector.self, forKey: .position)
        normal = try container.decode(Vector.self, forKey: .normal)
        textureCoordinates = try container.decode(Vector.self, forKey: .textureCoordinates)
        
        let color = try container.decodeIfPresent(Color.self, forKey: .color)
        
        self.color = color ?? .black
    }
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(position, forKey: .position)
        try container.encode(normal, forKey: .normal)
        try container.encode(color, forKey: .color)
        try container.encode(textureCoordinates, forKey: .textureCoordinates)
    }
}

extension Vertex {
    
    func inverted() -> Vertex {
        
        return Vertex(position: position, normal: -normal, color: color, textureCoordinates: textureCoordinates)
    }
    
    func lerp(vertex: Vertex, interpolater: Double) -> Vertex {
        
        return Vertex(position: position.lerp(vector: vertex.position, interpolater: interpolater), normal: normal.lerp(vector: vertex.normal, interpolater: interpolater), color: color, textureCoordinates: textureCoordinates.lerp(vector: vertex.textureCoordinates, interpolater: interpolater))
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

public extension Array where Element == Vertex {
    
    func inverted() -> Self {
            
        return map { $0.inverted() }
    }
    
    func translated(by translation: Vector) -> Self {
        
        return map { $0.translated(by: translation) }
    }
    
    func rotated(by rotation: Rotation) -> Self {
        
        return map { $0.rotated(by: rotation) }
    }
    
    func scaled(by scale: Vector) -> Self {
        
        return map { $0.scaled(by: scale) }
    }
    
    func transformed(by transform: Transform) -> Self {
        
        return map { $0.transformed(by: transform) }
    }
}
