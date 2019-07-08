//
//  SpriteButton.swift
//  Meadow
//
//  Created by Zack Brown on 03/05/2019.
//  Copyright © 2019 Script Orchard. All rights reserved.
//

import SpriteKit

public class SpriteButton: SKSpriteNode {
    
    public typealias SpriteButtonEvent = ((SpriteButton, ViewState) -> ())
    
    public var action: SpriteButtonEvent?
    
    lazy var stateObserver = {
       
        return SpriteButtonStateObserver(initialState: .idle)
    }()
    
    public init(imageNamed name: String, action: @escaping SpriteButtonEvent) {
        
        self.action = action
        
        let texture = SKTexture(imageNamed: name)
        
        super.init(texture: texture, color: .black, size: texture.size())
        
        self.isUserInteractionEnabled = true
        
        stateObserver.subscribe(stateDidChange(from:to:))
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        self.isUserInteractionEnabled = true
        
        stateObserver.subscribe(stateDidChange(from:to:))
    }
}

extension SpriteButton {
    
    func stateDidChange(from: ViewState?, to: ViewState) {
     
        DispatchQueue.main.async {
            
            self.action?(self, to)
        }
    }
}
