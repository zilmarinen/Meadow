//
//  Vector.swift
//  Meadow
//
//  Created by Zack Brown on 28/02/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

import Pasture

extension Vector {
    
    public init(vector: Vector, elevation: Int) {
        
        self.init(x: vector.x, y: World.Axis.y(value: elevation), z: vector.z)
    }
}
