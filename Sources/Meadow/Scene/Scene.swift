//
//  Scene.swift
//
//  Created by Zack Brown on 03/11/2020.
//

import SceneKit

class Scene: SCNScene {
    
    let meadow: Meadow
    
    var lastUpdate: TimeInterval?
    
    init(meadow: Meadow) {
        
        self.meadow = meadow
        
        super.init()
        
        rootNode.addChildNode(meadow)
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
}

extension Scene: SCNSceneRendererDelegate {

    public func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        
        let delta = time - (lastUpdate ?? time)
        
        meadow.update(delta: delta, time: time)
        
        lastUpdate = time
    }
}
