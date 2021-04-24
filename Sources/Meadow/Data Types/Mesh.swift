//
//  Mesh.swift
//
//  Created by Zack Brown on 03/11/2020.
//

import Foundation

open class Mesh: Hashable {
    
    private enum CodingKeys: String, CodingKey {
        
        case polygons = "p"
    }
    
    let polygons: [Polygon]
    
    public init(polygons: [Polygon]) {
        
        self.polygons = polygons
    }
    
    required public init(from decoder: Decoder) throws {
            
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        polygons = try container.decode([Polygon].self, forKey: .polygons)
    }
    
    required public init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(polygons, forKey: .polygons)
    }
}

extension Mesh {
    
    public static func == (lhs: Mesh, rhs: Mesh) -> Bool {
        
        return lhs.polygons == rhs.polygons
    }
    
    public func hash(into hasher: inout Hasher) {
        
        hasher.combine(polygons)
    }
}

extension Mesh: Transformable {
    
    public func translated(by translation: Vector) -> Mesh {
        
        return Mesh(polygons: polygons.translated(by: translation))
    }
    
    public func rotated(by rotation: Rotation) -> Mesh {
        
        return Mesh(polygons: polygons.rotated(by: rotation))
    }
    
    public func scaled(by scale: Vector) -> Mesh {
        
        return Mesh(polygons: polygons.scaled(by: scale))
    }
    
    public func transformed(by transform: Transform) -> Mesh {
        
        return Mesh(polygons: polygons.transformed(by: transform))
    }
}
