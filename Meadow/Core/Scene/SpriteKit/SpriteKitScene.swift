//
//  SpriteKitScene.swift
//  Meadow
//
//  Created by Zack Brown on 25/04/2019.
//  Copyright © 2019 Script Orchard. All rights reserved.
//

import SpriteKit

public class SpriteKitScene: SKScene {
    
    public let cameraJib = SpriteKitCamera()
    
    public override init() {
        
        super.init(size: CGSize.zero)
        
        self.name = "HUD"
        
        addChild(cameraJib)
        
        self.camera = cameraJib.camera
    }
    
    public required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func didMove(to view: SKView) {
        
        super.didMove(to: view)
        
        self.size = view.frame.size
    }
}

extension SpriteKitScene: SceneGraphUpdatable {
    
    public func update(deltaTime: TimeInterval) {
        
        guard !isPaused else { return }
        
        cameraJib.update(deltaTime: deltaTime)
    }
}
