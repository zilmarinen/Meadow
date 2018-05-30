//
//  MeshFace.swift
//  Meadow
//
//  Created by Zack Brown on 01/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import SceneKit

/*!
 @struct MeshFace
 @abstract Defines an array of vertices, normals and colors that define up a MeshFace.
 */
public struct MeshFace {
    
    /*!
     @property vertices
     @abstract Defines an array of vertices used to create the MeshFace.
     */
    let vertices: [SCNVector3]
    
    /*!
     @property normals
     @abstract Defines an array of normals used to create the MeshFace.
     */
    let normals: [SCNVector3]
    
    /*!
     @property faces
     @abstract Defines an array of colors used to create the MeshFace.
     */
    let colors: [SCNVector4]
    
    /*!
     @method init:vertices:normals:colors
     @abstract Creates and instantiates a MeshFace with the specified vertices, normals and colors.
     @param vertices Defines an array of vertices used to create the MeshFace.
     @param normals Defines an array of normals used to create the MeshFace.
     @param colors Defines an array of colors used to create the MeshFace.
     */
    init(vertices: [SCNVector3], normals: [SCNVector3], colors: [SCNVector4]) {
        
        self.vertices = vertices
        self.normals = normals
        self.colors = colors
    }
    
    /*!
     @method init:vertices:normal:colors
     @abstract Creates and instantiates a MeshFace with the specified vertices and colors, using the provided normal as a guide for the correct vertex winding.
     @param vertices Defines an array of vertices used to create the MeshFace.
     @param referenceNormal Defines a normal around which the vertices should be wound.
     @param colors Defines an array of colors used to create the MeshFace.
     */
    init(vertices: [SCNVector3], referenceNormal: SCNVector3, colors: [SCNVector4]) {
        
        let plane = Plane(v0: vertices[0], v1: vertices[1], v2: vertices[2])
        
        var planeVertices: [SCNVector3] = vertices
        var planeNormal: SCNVector3 = plane.normal
        
        if plane.side(vector: referenceNormal) {
            
            planeVertices[1] = vertices[2]
            planeVertices[2] = vertices[1]
            
            planeNormal = plane.normal.negated()
        }
        
        self.vertices = planeVertices
        self.colors = colors
        self.normals = [planeNormal, planeNormal, planeNormal]
    }
}
