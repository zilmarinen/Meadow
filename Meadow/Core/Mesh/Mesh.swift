//
//  Mesh.swift
//  Meadow
//
//  Created by Zack Brown on 11/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import SceneKit

/*!
 @struct Mesh
 @abstract Defines an array of MeshFaces.
 */
struct Mesh {
    
    /*!
     @property faces
     @abstract Defines an array of faces used to create the Mesh.
     */
    let faces: [MeshFace]
    
    /*
     @property triangles
     @abstract Defines an array of triangles used to create the mesh.
     */
    let triangles: [MeshTriangle]
    
    /*!
     @method init:faces:trianges
     @abstract Creates and instantiates a Mesh with the specified faces and trianges.
     @param faces An array of MeshFaces that define the Mesh.
     @param trianges An array of MeshTrianges that define the Mesh.
     */
    init(faces: [MeshFace], triangles: [MeshTriangle]) {
        
        self.faces = faces
        self.triangles = triangles
    }
    
    /*!
     @method init:meshes
     @abstract Creates and instantiates a compound Mesh by combining the specified Meshes.
     @param meshes An array of Meshes to be combined.
     */
    init(meshes: [Mesh]) {
        
        var meshTriangles: [MeshTriangle] = []
        
        var offset = Int32(0)
        
        meshes.forEach { mesh in
            
            mesh.triangles.forEach({ triangle in
                
                meshTriangles.append(MeshTriangle(i0: triangle.i0 + offset, i1: triangle.i1 + offset, i2: triangle.i2 + offset))
            })
            
            offset += Int32(mesh.triangles.count)
        }
        
        self.faces = meshes.flatMap { $0.faces }
        self.triangles = meshTriangles
    }
}

extension Mesh {
    
    /*!
     @property Quad
     @abstract Returns a quad Mesh with unit grid length vertices.
     */
    static var Quad: Mesh {
        
        let polytope = Polytope.Unit
        
        let v0 = polytope.vertices[0]
        let v1 = polytope.vertices[1]
        let v2 = polytope.vertices[2]
        let v3 = polytope.vertices[3]
        
        let color = SCNVector4(x: 1.0, y: 0.0, z: 1.0, w: 1.0)
        let normal = SCNVector3(x: 0.0, y: 1.0, z: 0.0)
        
        let colors = [ color, color, color ]
        let normals = [ normal, normal, normal ]
        
        let f0 = MeshFace(vertices: [v0, v1, v2], normals: normals, colors: colors)
        let f1 = MeshFace(vertices: [v0, v2, v3], normals: normals, colors: colors)
        
        let t0 = MeshTriangle(i0: 0, i1: 1, i2: 2)
        let t1 = MeshTriangle(i0: 3, i1: 4, i2: 5)
        
        return Mesh(faces: [f0, f1], triangles: [t0, t1])
    }
}
