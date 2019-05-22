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
    
    public let scene: SceneKitScene
    
    public let hud: SpriteKitScene
    
    public let view: SceneKitView
    
    var lastUpdate: TimeInterval?
    
    public var delegate: SceneRendererDelegate?
    
    public init(input: Input, scene: SceneKitScene, hud: SpriteKitScene, view: SceneKitView) {
        
        self.input = input
        
        self.scene = scene
        
        self.hud = hud
        
        self.view = view
        
        super.init()
        
        self.view.viewModel.state = .scene(meadow: self)
    }
}

extension Meadow: SCNSceneRendererDelegate {
    
    public func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        
        let deltaTime = time - (self.lastUpdate ?? time)
        
        switch self.view.viewModel.state {
            
        case .scene(let meadow):
            
            meadow.scene.update(deltaTime: deltaTime)
            meadow.hud.update(deltaTime: deltaTime)
            
            delegate?.update(deltaTime: deltaTime, frameTime: renderer.sceneTime)
            
        default: break
        }
        
        self.lastUpdate = time
    }
}
