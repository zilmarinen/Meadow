//
//  ViewCoordinator.swift
//
//  Created by Zack Brown on 18/03/2021.
//

import Foundation
import Meadow
import SceneKit

class ViewCoordinator: Coordinator<GameViewController>, SCNSceneRendererDelegate, Updatable {
    
    private(set) public var lastUpdate: TimeInterval?
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        
        let delta = time - (lastUpdate ?? time)
        
        update(delta: delta, time: time)
        
        lastUpdate = time
    }
    
    func update(delta: TimeInterval, time: TimeInterval) {}
}
