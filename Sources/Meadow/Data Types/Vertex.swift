//
//  Vertex.swift
//
//  Created by Zack Brown on 03/11/2020.
//

import Foundation

struct Vertex: Hashable {
    
    let position: Vector
    let normal: Vector
    let color: Color
    let textureCoordinates: CGPoint
    
    init(position: Vector, normal: Vector, color: Color = .black, textureCoordinates: CGPoint = .zero) {
        
        self.position = position.quantized()
        self.normal = normal.normalised()
        self.color = color
        self.textureCoordinates = textureCoordinates
    }
}

extension Vertex {
    
    func equal(to vertex: Vertex) -> Bool {
        
        return position.equal(to: vertex.position) && normal.equal(to: vertex.normal) && color == vertex.color && textureCoordinates.equal(to: vertex.textureCoordinates)
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
