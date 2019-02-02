//
//  Hero.swift
//  Meadow
//
//  Created by Zack Brown on 12/11/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import SceneKit

public class Hero: SCNNode, SceneGraphChild {
    
    public var observer: SceneGraphObserver?
    
    public var volume: Volume { return Volume(coordinate: Coordinate.zero, size: Size.one) }
}
