//
//  MeshTriangle.swift
//  Meadow
//
//  Created by Zack Brown on 11/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

/*!
 @struct MeshTriangle
 @abstract Defines an array of MeshFace triangle indices.
 */
struct MeshTriangle {
    
    /*!
     @property i0
     @abstract Defines a single triangle index as part of a MeshFace.
     */
    let i0: Int32
    
    /*!
     @property i1
     @abstract Defines a single triangle index as part of a MeshFace.
     */
    let i1: Int32
    
    /*!
     @property i2
     @abstract Defines a single triangle index as part of a MeshFace.
     */
    let i2: Int32
    
    /*!
     @property indices
     @abstract Defines an array of triangle indices that define a MeshFace.
     */
    var indices: [Int32] { return [i0, i1, i2] }
}

