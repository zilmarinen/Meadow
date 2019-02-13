//
//  SceneView_iOS.swift
//  Meadow
//
//  Created by Zack Brown on 26/09/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import SceneKit

extension SceneView {
    
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        switch viewModel.state {
            
        case .scene(let meadow):
            
            switch meadow.input.cursor.state {
                
            case .idle:
                
                guard let touch = touches.first else { break }
                
                let position = touch.location(in: self)
                
                let inputType: CursorState.InputType = (touch.tapCount == 1 ? .left : .right)
                
                meadow.input.cursor.state = .down(position: position, inputType: inputType)
                
            default: break
            }
            
        default: break
        }
    }
    
    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        switch viewModel.state {
            
        case .scene(let meadow):
            
            switch meadow.input.cursor.state {
                
            case .down(let startPosition, let inputType),
                 .tracking(_, let inputType, let startPosition):
                
                guard let touch = touches.first else { break }
                
                let position = touch.location(in: self)
                
                meadow.input.cursor.state = .up(position: position, inputType: inputType, startPosition: startPosition)
                
            default: break
            }
            
        default: break
        }
    }
    
    override public func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        switch viewModel.state {
            
        case .scene(let meadow):
            
            switch meadow.input.cursor.state {
                
            case .down(let startPosition, let inputType),
                 .tracking(_, let inputType, let startPosition):
                
                guard let touch = touches.first else { break }
                
                let position = touch.location(in: self)
                
                meadow.input.cursor.state = .tracking(position: position, inputType: inputType, startPosition: startPosition)
                
            default: break
            }
            
        default: break
        }
    }
}
