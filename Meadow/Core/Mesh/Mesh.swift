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
        
        var offset = 0
        
        meshes.forEach { mesh in
            
            mesh.triangles.forEach({ triangle in
                
                meshTriangles.append(MeshTriangle(i0: triangle.i0 + offset, i1: triangle.i1 + offset, i2: triangle.i2 + offset))
            })
            
            offset += mesh.triangles.count
        }
        
        self.faces = meshes.flatMap { $0.faces }
        self.triangles = meshTriangles
    }
}
