//
//  SpriteKitScene_macOS.swift
//  Meadow-macOS
//
//  Created by Zack Brown on 28/07/2019.
//  Copyright © 2019 Script Orchard. All rights reserved.
//

extension SpriteKitScene {
    
    open override func mouseUp(with event: NSEvent) {
        
        super.mouseUp(with: event)
        
        mouseUp(event: event, eventType: .left)
    }
    
    open override func rightMouseUp(with event: NSEvent) {
        
        super.rightMouseUp(with: event)
        
        mouseUp(event: event, eventType: .right)
    }
}

extension SpriteKitScene {
    
    func mouseUp(event: NSEvent, eventType: SpriteButton.EventType) {
        
        let point = event.location(in: self)
        
        guard let button = atPoint(point) as? SpriteButton else { return }
        
        button.action?(button, eventType)
    }
}
