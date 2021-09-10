//
//  SCNVector3.swift
//
//  Created by Zack Brown on 03/11/2020.
//

import SceneKit

extension SCNVector3 {
    
    init(coordinate: Coordinate) {
        
        self.init(coordinate.x, coordinate.y, coordinate.z)
    }
}

extension SCNVector3 {

    static var zero = SCNVector3(x: 0, y: 0, z: 0)
    static var left = SCNVector3(x: 1, y: 0, z: 0)
    static var right = SCNVector3(x: -1, y: 0, z: 0)
    static var forward = SCNVector3(x: 0, y: 0, z: 1)
    static var backward = SCNVector3(x: 0, y: 0, z: -1)
    static var up = SCNVector3(x: 0, y: 1, z: 0)
    static var down = SCNVector3(x: 0, y: -1, z: 0)
}
