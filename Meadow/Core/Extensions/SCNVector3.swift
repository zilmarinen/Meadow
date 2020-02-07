//
//  SCNVector3.swift
//  Meadow
//
//  Created by Zack Brown on 07/02/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

import SceneKit

extension SCNVector3 {

    public static func ==(lhs: SCNVector3, rhs: SCNVector3) -> Bool {

        return lhs.x == rhs.x && lhs.y == rhs.y && lhs.z == rhs.z
    }

    public static func ~=(lhs: SCNVector3, rhs: SCNVector3) -> Bool {

        let threshold = CGFloat(0.1)

        return ((lhs.x >= (rhs.x - threshold) && lhs.x <= (rhs.x + threshold)) &&
                (lhs.y >= (rhs.y - threshold) && lhs.y <= (rhs.y + threshold)) &&
                (lhs.z >= (rhs.z - threshold) && lhs.z <= (rhs.z + threshold)))
    }

    public static func +(lhs: SCNVector3, rhs: SCNVector3) -> SCNVector3 {

        return SCNVector3(x: lhs.x + rhs.x,
                          y: lhs.y + rhs.y,
                          z: lhs.z + rhs.z)
    }

    public static func +=(lhs: inout SCNVector3, rhs: SCNVector3) {

        lhs = lhs + rhs
    }

    public static func -(lhs: SCNVector3, rhs: SCNVector3) -> SCNVector3 {

    return SCNVector3(x: lhs.x - rhs.x,
                      y: lhs.y - rhs.y,
                      z: lhs.z - rhs.z)
    }

    public static func -=(lhs: inout SCNVector3, rhs: SCNVector3) {

        lhs = lhs - rhs
    }
}
