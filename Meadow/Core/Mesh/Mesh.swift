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
public struct Mesh {
    
    /*!
     @property faces
     @abstract Defines an array of faces used to create the Mesh.
     */
    public let faces: [MeshFace]
    
    /*
     @property triangles
     @abstract Defines an array of triangles used to create the mesh.
     */
    public let triangles: [MeshTriangle]
    
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
     @method init:faces
     @abstract Creates and instantiates a Mesh with the specified faces.
     @param faces An array of MeshFaces that define the Mesh.
     */
    init(faces: [MeshFace]) {
        
        var meshTriangles: [MeshTriangle] = []
        
        for index in 0..<faces.count {
            
            let offset = Int32(index * 3)
            
            meshTriangles.append(MeshTriangle(i0: offset, i1: offset + 1, i2: offset + 2))
        }
        
        self.init(faces: faces, triangles: meshTriangles)
    }
    
    /*!
     @method init:meshes
     @abstract Creates and instantiates a compound Mesh by combining the specified Meshes.
     @param meshes An array of Meshes to be combined.
     */
    init(meshes: [Mesh]) {
        
        self.init(faces: meshes.flatMap { $0.faces })
    }
}
