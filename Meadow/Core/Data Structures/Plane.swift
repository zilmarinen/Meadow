//
//  Plane.swift
//  Meadow-iOS
//
//  Created by Zack Brown on 30/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import SceneKit

/*!
 @struct Plane
 @abstract Defines a flat, two-dimensional surface that extends infinitely far.
 */
public struct Plane {
    
    /*!
     @param normal
     @abstract
     */
    public let normal: SCNVector3
    
    /*!
     @param direction
     @abstract
     */
    let direction: MDWFloat
    
    /*!
     @param direction
     @abstract Create a plane from three SCNVector3.
     @param v0 A SCNVector3 defining a point on the plane.
     @param v1 A SCNVector3 defining a point on the plane.
     @param v2 A SCNVector3 defining a point on the plane.
     */
    init(v0: SCNVector3, v1: SCNVector3, v2: SCNVector3) {
        
        let ab = v1 - v0
        let ac = v2 - v0
        
        let cross = SCNVector3.Cross(lhs: ab, rhs: ac)
        
        self.normal = cross.normalised()
        
        self.direction = -SCNVector3.Dot(lhs: self.normal, rhs: v0)
    }
    
    /*!
     @method
     @abstract
     @param
     */
    public func side(vector: SCNVector3) -> Bool {
        
        let dot = SCNVector3.Dot(lhs: vector, rhs: normal)
        
        return dot > 0
    }
}
