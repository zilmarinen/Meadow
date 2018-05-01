//
//  Meadow.swift
//  Meadow
//
//  Created by Zack Brown on 27/04/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import SceneKit

public class Meadow: SCNScene {
    
    let areas = Area()
    let foliage = Foliage()
    let footpaths = Footpath()
    let scaffolds = Scaffold()
    let terrain = Terrain()
    let tunnels = Tunnel()
    let water = Water()
}

extension Meadow: SCNSceneRendererDelegate {
    
    public func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        
        //
    }
}
