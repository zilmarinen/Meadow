//
//  SCNGeometry+Mesh.swift
//  Meadow
//
//  Created by Zack Brown on 11/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import SceneKit

extension SCNGeometry {
    
    /*!
     @method init:mesh
     @abstract Creates and instantiates SCNGeometry with the specified Mesh.
     @param mesh The Mesh defining the vertices, normals, colors and triangle indicies of the geometry.
     */
    convenience init(mesh: Mesh) {
        
        let indices = mesh.triangles.flatMap { $0.indices }
        let vertices = mesh.faces.flatMap { $0.vertices }
        let normals = mesh.faces.flatMap { $0.normals }
        let colors = mesh.faces.flatMap { $0.colors }
        
        let floatSize = MemoryLayout<SCNFloat>.size
        let vectorSize = MemoryLayout<SCNVector3>.size
        
        let colorData = Data(bytes: colors, count: vectorSize * colors.count)
        
        let colorSource = SCNGeometrySource(data: colorData, semantic: .color, vectorCount: colors.count, usesFloatComponents: true, componentsPerVector: 3, bytesPerComponent: floatSize, dataOffset: 0, dataStride: vectorSize)
        
        let vertexSource = SCNGeometrySource(vertices: vertices)
        
        let normalSource = SCNGeometrySource(normals: normals)
        
        let element = SCNGeometryElement(indices: indices, primitiveType: .triangles)
        
        self.init(sources: [vertexSource, normalSource, colorSource], elements: [element])
    }
}
