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
}
