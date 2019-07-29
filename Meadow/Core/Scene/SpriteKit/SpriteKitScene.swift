//
//  SpriteKitScene.swift
//  Meadow
//
//  Created by Zack Brown on 20/07/2019.
//  Copyright © 2019 Script Orchard. All rights reserved.
//

import SpriteKit

open class SpriteKitScene: SKScene {
    
    public lazy var model = {
        
        return SpriteKitSceneStateObserver(initialState: .empty)
    }()
    
    open override func sceneDidLoad() {
        
        super.sceneDidLoad()
        
        self.isUserInteractionEnabled = true
        
        model.subscribe(stateDidChange(from:to:))
    }
}

extension SpriteKitScene {
    
    func stateDidChange(from: SceneState?, to: SceneState) {

        switch to {
            
        case .empty:
            
            print("SpriteKitScene -> empty")
            
            guard let from = from else { break }
                
            switch from {
                
            case .alert(let controller):
                
                controller.removeFromParent()
                    
            default: break
            }
            
        case .alert(let controller):
            
            print("SpriteKitScene -> alert")
            
            self.addChild(controller)
            
            controller.layout()
        }
    }
}
