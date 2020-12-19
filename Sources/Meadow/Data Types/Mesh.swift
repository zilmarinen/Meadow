//
//  Mesh.swift
//
//  Created by Zack Brown on 03/11/2020.
//

public struct Mesh: Hashable {
    
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
    
    func merge(mesh: Mesh) -> Mesh {
        
        return Mesh(polygons: polygons + mesh.polygons)
    }
}
