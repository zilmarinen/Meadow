//
//  SCNGeometry+Mesh.swift
//  Meadow
//
//  Created by Zack Brown on 11/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import SceneKit

extension SCNGeometry {
    
    public convenience init(mesh: Mesh) {
        
        let indices = mesh.triangles.flatMap { $0.indices }
        let vertices = mesh.faces.flatMap { $0.vertices }
        let normals = mesh.faces.flatMap { $0.normals }
        let colors = mesh.faces.flatMap { $0.colors }
        
        let floatSize = MemoryLayout<MDWFloat>.size
        let colorSize = MemoryLayout<SCNVector4>.size
        
        let colorData = Data(bytes: colors, count: colorSize * colors.count)
        
        let colorSource = SCNGeometrySource(data: colorData, semantic: .color, vectorCount: colors.count, usesFloatComponents: true, componentsPerVector: 4, bytesPerComponent: floatSize, dataOffset: 0, dataStride: 0)
        
        let vertexSource = SCNGeometrySource(vertices: vertices)
        
        let normalSource = SCNGeometrySource(normals: normals)
        
        let element = SCNGeometryElement(indices: indices, primitiveType: .triangles)
        
        self.init(sources: [vertexSource, normalSource, colorSource], elements: [element])
    }
}
