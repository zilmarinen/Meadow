//
//  SpriteButton.swift
//  Meadow
//
//  Created by Zack Brown on 03/05/2019.
//  Copyright © 2019 Script Orchard. All rights reserved.
//

import SpriteKit

public class SpriteButton: SKSpriteNode {
    
    public typealias SpriteButtonAction = ((SpriteButton, EventType) -> ())
    
    public enum EventType {
        
        case left
        case middle
        case right
    }
    
    public var action: SpriteButtonAction?
    
    public init(imageNamed name: String? = nil, color: Color, size: CGSize, action: @escaping SpriteButtonAction) {
        
        self.action = action
        
        var texture: SKTexture?
        
        if let name = name {
            
            texture = SKTexture(imageNamed: name)
        }
        
        super.init(texture: texture, color: color.color, size: size)
        
        self.isUserInteractionEnabled = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        self.isUserInteractionEnabled = false
    }
}
