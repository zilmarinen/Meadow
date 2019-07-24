//
//  Meadow.swift
//  Meadow
//
//  Created by Zack Brown on 08/10/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import SceneKit

public class Meadow: NSObject {
    
    public let input: Input
    
    public let view: SceneKitView
    
    let observer: SceneGraphObserver?
    
    let delegate: SceneRendererDelegate?
    
    public var scene: SceneKitScene { return view.scene as! SceneKitScene }
    
    var lastUpdate: TimeInterval?
    
    public init(input: Input, view: SceneKitView, observer: SceneGraphObserver? = nil, delegate: SceneRendererDelegate? = nil) {
        
        self.input = input
        
        self.view = view
        
        self.observer = observer
        
        self.delegate = delegate
        
        super.init()
        
        self.view.stateObserver.state = .scene(meadow: self, scene: SceneKitScene(observer: self))
    }
}

extension Meadow: SceneGraphObserver {
    
    public func child(didBecomeDirty child: SceneGraphChild) {
        
        observer?.child(didBecomeDirty: child)
    }
}

extension Meadow: SCNSceneRendererDelegate {
    
    public func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        
        let deltaTime = time - (self.lastUpdate ?? time)
        
        switch self.view.stateObserver.state {
            
        case .scene(_, let scene):
            
            scene.update(deltaTime: deltaTime)
            
            delegate?.update(deltaTime: deltaTime, frameTime: renderer.sceneTime)
            
        default: break
        }
        
        self.lastUpdate = time
    }
}
