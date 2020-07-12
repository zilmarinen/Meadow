//
//  GridMeshBuilder.swift
//  Meadow
//
//  Created by Zack Brown on 06/07/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

import Pasture

protocol GridMeshBuilder {
    
    func numberOfPolyhedrons(for cardinal: Cardinal) -> Int
    
    func polytope(forApex cardinal: Cardinal, atIndex index: Int) -> GridMesh.Polytope?
    func polytope(forThrone cardinal: Cardinal, atIndex index: Int) -> GridMesh.Polytope?
    
    func intersection(for cardinal: Cardinal, neighbour: Cardinal) -> GridMesh.EdgeSegment?
    
    func shouldRender(apex cardinal: Cardinal, atIndex index: Int) -> Bool
    func shouldRender(face cardinal: Cardinal, atIndex index: Int) -> Bool
    
    func colorPalette(apex cardinal: Cardinal, atIndex index: Int) -> ColorPalette
    func colorPalette(face cardinal: Cardinal, atIndex index: Int) -> ColorPalette
    
    func build(cardinal: Cardinal) -> [Pasture.Polygon]?
    
    func apex(for cardinal: Cardinal, polyhedron: GridMesh.Polyhedron, atIndex index: Int) -> Pasture.Polygon?
    func edge(for cardinal: Cardinal, face: GridMesh.Face, intersection: GridMesh.EdgeSegment?, atIndex index: Int) -> [Pasture.Polygon]?
}

extension GridMeshBuilder {
    
    func build(cardinal: Cardinal) -> [Pasture.Polygon]? {
        
        let totalPolyhedrons = numberOfPolyhedrons(for: cardinal)
        
        guard totalPolyhedrons > 0 else { return nil }
        
        let (c1, c2) = cardinal.cardinals
        
        let n0 = cardinal.normal
        let n1 = cardinal.normal(neighbour: c1)
        let n2 = cardinal.normal(neighbour: c2)
        
        var intersections: [Cardinal: GridMesh.EdgeSegment] = [:]
        
        intersections[cardinal] = intersection(for: cardinal, neighbour: cardinal)
        intersections[c1] = intersection(for: cardinal, neighbour: c1)
        intersections[c2] = intersection(for: cardinal, neighbour: c2)
        
        var polygons: [Pasture.Polygon] = []
        
        for index in 0..<totalPolyhedrons {
            
            guard let apexPolytope = polytope(forApex: cardinal, atIndex: index), let thronePolytope = polytope(forThrone: cardinal, atIndex: index) else { continue }
            
            let polyhedron = GridMesh.Polyhedron(upper: apexPolytope, lower: thronePolytope)
            
            if let face = apex(for: cardinal, polyhedron: polyhedron, atIndex: index) {
                
                polygons.append(face)
            }
            
            let faces = [(GridMesh.Face(polyhedron: polyhedron, face: .front, normal: n0), intersections[cardinal]),
                         (GridMesh.Face(polyhedron: polyhedron, face: .right, normal: n1), intersections[c1]),
                         (GridMesh.Face(polyhedron: polyhedron, face: .left, normal: n2), intersections[c2])]
            
            faces.forEach { (face, intersection) in
                
                polygons.append(contentsOf: edge(for: cardinal, face: face, intersection: intersection, atIndex: index) ?? [])
            }
        }
        
        return polygons
    }
}
