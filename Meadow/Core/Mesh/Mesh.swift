//
//  Mesh.swift
//  Meadow
//
//  Created by Zack Brown on 11/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import SceneKit

public struct Mesh {

    public let faces: [MeshFace]
    
    public let triangles: [MeshTriangle]

    init(faces: [MeshFace], triangles: [MeshTriangle]) {
        
        self.faces = faces
        self.triangles = triangles
    }
    
    init(faces: [MeshFace]) {
        
        var meshTriangles: [MeshTriangle] = []
        
        for index in 0..<faces.count {
            
            let offset = Int32(index * 3)
            
            meshTriangles.append(MeshTriangle(i: offset, j: offset + 1, k: offset + 2))
        }
        
        self.init(faces: faces, triangles: meshTriangles)
    }

    init(meshes: [Mesh]) {
        
        self.init(faces: meshes.flatMap { $0.faces })
    }
}
