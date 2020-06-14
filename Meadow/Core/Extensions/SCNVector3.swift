//
//  SCNVector3.swift
//  Meadow
//
//  Created by Zack Brown on 01/06/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

import Pasture
import SceneKit

extension SCNVector3 {
    
    public init(coordinate: Coordinate) {
        
        self.init(x: SKFloat(coordinate.x), y: SKFloat(World.Axis.y(y: coordinate.y)), z: SKFloat(coordinate.z))
    }
}
