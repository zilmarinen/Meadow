//
//  GridMeshBuilder.swift
//  Meadow
//
//  Created by Zack Brown on 06/07/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

import Pasture

protocol GridMeshBuilder {
    
    func numberOfPolyhedrons(for edge: Int) -> Int
    
    func neighbourIndices(for edge: Int) -> (i0: Int, i1: Int)
    
    func polytope(forApex edge: Int, atIndex index: Int) -> GridMesh.Polytope?
    func polytope(forThrone edge: Int, atIndex index: Int) -> GridMesh.Polytope?
    
    func intersection(for edge: Int, neighbour: Int) -> GridMesh.EdgeSegment?
    func normal(for edge: Int, neighbour: Int) -> Vector
    func vertices(for edge: Int) -> (v0: Vector, centre: Vector, v1: Vector)
    
    func shouldRender(apex edge: Int, atIndex index: Int) -> Bool
    func shouldRender(face edge: Int, atIndex index: Int) -> Bool
    
    func colorPalette(apex edge: Int, atIndex index: Int) -> ColorPalette
    func colorPalette(face edge: Int, atIndex index: Int) -> ColorPalette
    
    func build(edge: Int) -> [Pasture.Polygon]?
    
    func apex(for edge: Int, polyhedron: GridMesh.Polyhedron, atIndex index: Int) -> Pasture.Polygon?
    func side(for edge: Int, face: GridMesh.Face, intersection: GridMesh.EdgeSegment?, atIndex index: Int) -> [Pasture.Polygon]?
}

extension GridMeshBuilder {
    
    func build(edge: Int) -> [Pasture.Polygon]? {

        let totalPolyhedrons = numberOfPolyhedrons(for: edge)

        guard totalPolyhedrons > 0 else { return nil }
        
        let (i0, i1) = neighbourIndices(for: edge)

        var intersections: [Int: GridMesh.EdgeSegment] = [:]

        intersections[edge] = intersection(for: edge, neighbour: edge)
        intersections[i0] = intersection(for: edge, neighbour: i0)
        intersections[i1] = intersection(for: edge, neighbour: i1)
        
        var normals: [Int: Vector] = [:]
        
        normals[edge] = normal(for: edge, neighbour: edge)
        normals[i0] = normal(for: edge, neighbour: i0)
        normals[i1] = normal(for: edge, neighbour: i1)
        
        var polygons: [Pasture.Polygon] = []

        for index in 0..<totalPolyhedrons {

            guard let apexPolytope = polytope(forApex: edge, atIndex: index), let thronePolytope = polytope(forThrone: edge, atIndex: index) else { continue }

            let polyhedron = GridMesh.Polyhedron(upper: apexPolytope, lower: thronePolytope)

            if let face = apex(for: edge, polyhedron: polyhedron, atIndex: index) {

                polygons.append(face)
            }
            
            let faces = [(GridMesh.Face(polyhedron: polyhedron, face: .front, normal: normals[edge]!), intersections[edge]),
                         (GridMesh.Face(polyhedron: polyhedron, face: .right, normal: normals[i0]!), intersections[i0]),
                         (GridMesh.Face(polyhedron: polyhedron, face: .left, normal: normals[i1]!), intersections[i1])]
            
            faces.forEach { (face, intersection) in

                polygons.append(contentsOf: side(for: edge, face: face, intersection: intersection, atIndex: index) ?? [])
            }
        }

        return polygons
    }
}
