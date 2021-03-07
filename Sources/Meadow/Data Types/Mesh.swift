//
//  Mesh.swift
//
//  Created by Zack Brown on 03/11/2020.
//

public class Mesh: Hashable {
    
    enum Faces {
        
        case back
        case front
        case both
    }
    
    let polygons: [Polygon]
    
    lazy var bounds: Bounds = {
    
        return Bounds(vectors: polygons.flatMap { $0.vertices.map { $0.position } })
    }()
    
    public init(polygons: [Polygon]) {
        
        self.polygons = polygons
    }
}

extension Mesh {
    
    public static func == (lhs: Mesh, rhs: Mesh) -> Bool {
        
        return lhs.polygons == rhs.polygons && lhs.bounds == rhs.bounds
    }
    
    public func hash(into hasher: inout Hasher) {
        
        hasher.combine(polygons)
        hasher.combine(bounds)
    }
}

extension Mesh {
    
    func merge(mesh: Mesh) -> Mesh {
        
        return Mesh(polygons: polygons + mesh.polygons)
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
