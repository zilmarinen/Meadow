//
//  Meadow.swift
//  Meadow
//
//  Created by Zack Brown on 07/02/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

import SceneKit

class Meadow: SCNNode {
    
    var lastUpdate: TimeInterval?
    
    let area = Area()
    let foliage = Foliage()
    let footpath = Footpath()
    let terrain = Terrain()
    let water = Water()
    
    override init() {
        
        super.init()
        
        addChildNode(area)
        addChildNode(foliage)
        addChildNode(footpath)
        addChildNode(terrain)
        addChildNode(water)
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
}

extension Meadow: SCNSceneRendererDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        
        let delta = time - (lastUpdate ?? time)
        
        area.update(delta: delta, time: time)
        foliage.update(delta: delta, time: time)
        footpath.update(delta: delta, time: time)
        terrain.update(delta: delta, time: time)
        water.update(delta: delta, time: time)
        
        lastUpdate = time
    }
}
