//
//  SceneView_iOS.swift
//  Meadow
//
//  Created by Zack Brown on 26/09/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import SceneKit

extension SceneView {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        switch viewModel.state {
            
        case .scene(_, let cursorModel):
            
            switch cursorModel.state {
                
            case .idle:
                
                guard let touch = touches.first else { break }
                
                let position = touch.location(in: self)
                
                let inputType: CursorState.InputType = (touch.tapCount == 1 ? .left : .right)
                
                cursorModel.state = .down(inputType: inputType, position: position)
                
            default: break
            }
            
        default: break
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        switch viewModel.state {
            
        case .scene(_, let cursorModel):
            
            switch cursorModel.state {
                
            case .down(let inputType, let startPosition),
                 .tracking(let inputType, let startPosition, _):
                
                guard let touch = touches.first else { break }
                
                let position = touch.location(in: self)
                
                cursorModel.state = .up(inputType: inputType, startPosition: startPosition, position: position)
                
            default: break
            }
            
        default: break
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        switch viewModel.state {
            
        case .scene(_, let cursorModel):
            
            switch cursorModel.state {
                
            case .down(let inputType, let startPosition),
                 .tracking(let inputType, let startPosition, _):
                
                guard let touch = touches.first else { break }
                
                let position = touch.location(in: self)
                
                cursorModel.state = .tracking(inputType: inputType, startPosition: startPosition, position: position)
                
            default: break
            }
            
        default: break
        }
    }
}
