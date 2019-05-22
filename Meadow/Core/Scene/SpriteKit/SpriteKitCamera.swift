//
//  SpriteKitCamera.swift
//  Meadow
//
//  Created by Zack Brown on 09/05/2019.
//  Copyright © 2019 Script Orchard. All rights reserved.
//

import SpriteKit

public class SpriteKitCamera: SKNode {
    
    public let camera = SKCameraNode()
    
    public lazy var model = {
        
        return SpriteKitCameraModel(initialState: .focus(point: CGPoint.zero, zoom: 0))
    }()
    
    public override init() {
        
        super.init()
        
        self.name = "Camera"
        
        addChild(camera)
        
        self.model.subscribe(stateDidChange(from:to:))
    }
    
    public required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
}

extension SpriteKitCamera {
    
    func stateDidChange(from: CameraState?, to: CameraState) {
        
        switch to {
            
        default: break
        }
    }
}

extension SpriteKitCamera: SceneGraphUpdatable {
    
    public func update(deltaTime: TimeInterval) {
        
        switch model.state {
            
        default: break
        }
    }
}
