//
//  Scene.swift
//  Meadow
//
//  Created by Zack Brown on 19/05/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

import SceneKit

public class Scene: SCNScene {
    
    public let meadow: Meadow
    
    public let camera = Camera()
    
    public let blueprint: Blueprint
    
    var lastUpdate: TimeInterval?
    
    public init(meadow: Meadow) {
        
        self.meadow = meadow
        
        self.blueprint = Blueprint(graph: meadow.graph)
        
        super.init()
        
        rootNode.addChildNode(meadow)
        rootNode.addChildNode(camera)
        rootNode.addChildNode(blueprint)
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
}

extension Scene: SCNSceneRendererDelegate {

    public func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        
        let delta = time - (lastUpdate ?? time)
        
        meadow.update(delta: delta, time: time)
        camera.update(delta: delta, time: time)
        
        meadow.clean()
        
        lastUpdate = time
    }
}
