//
//  SpriteKitScene_iOS.swift
//  Meadow-iOS
//
//  Created by Zack Brown on 28/07/2019.
//  Copyright © 2019 Script Orchard. All rights reserved.
//

extension SpriteKitScene {
    
    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        super.touchesEnded(touches, with: event)
        
        guard let touch = touches.first else { return }
        
        let point = touch.location(in: self)
        
        guard let button = atPoint(point) as? SpriteButton else { return }
        
        let eventType: SpriteButton.EventType = (touch.tapCount == 1 ? .left : .right)
        
        button.action?(button, eventType)
    }
}
