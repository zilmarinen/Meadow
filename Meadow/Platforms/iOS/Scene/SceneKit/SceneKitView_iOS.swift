//
//  SceneView_iOS.swift
//  Meadow
//
//  Created by Zack Brown on 26/09/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import SceneKit

extension SceneKitView {
    
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        super.touchesBegan(touches, with: event)
        
        switch stateObserver.state {
            
        case .scene(let meadow, _):
            
            switch meadow.input.cursor.state {
                
            case .idle:
                
                guard let touch = touches.first else { break }
                
                let point = touch.location(in: self)
                
                let inputType: CursorState.InputType = (touch.tapCount == 1 ? .left : .right)
                
                meadow.input.cursor.state = .down(position: (start: point, end: point), inputType: inputType)
                
            default: break
            }
            
        default: break
        }
    }
    
    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        super.touchesEnded(touches, with: event)
        
        switch stateObserver.state {
            
        case .scene(let meadow, _):
            
            switch meadow.input.cursor.state {
                
            case .down(let position, let inputType),
                 .tracking(let position, let inputType):
                
                guard let touch = touches.first else { break }
                
                let point = touch.location(in: self)
                
                meadow.input.cursor.state = .up(position: (start: position.start, end: point), inputType: inputType)
                
            default: break
            }
            
        default: break
        }
    }
    
    override public func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        super.touchesMoved(touches, with: event)
        
        switch stateObserver.state {
            
        case .scene(let meadow, _):
            
            switch meadow.input.cursor.state {
                
            case .down(let position, let inputType),
                 .tracking(let position, let inputType):
                
                guard let touch = touches.first else { break }
                
                let point = touch.location(in: self)
                
                meadow.input.cursor.state = .tracking(position: (start: position.start, end: point), inputType: inputType)
                
            default: break
            }
            
        default: break
        }
    }
}
