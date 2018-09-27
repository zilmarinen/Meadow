//
//  SceneView_macOS.swift
//  Meadow
//
//  Created by Zack Brown on 26/09/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import SceneKit

extension SceneView {
    
    public override func mouseDown(with event: NSEvent) {
        
        switch viewModel.state {
            
        case .scene(_, let cursorModel):
            
            switch cursorModel.state {
                
            case .idle:
                
                let pointInView = convert(event.locationInWindow, from: nil)
                
                let position = CGPoint(x: pointInView.x, y: pointInView.y)
                
                let inputType: CursorState.InputType = (event.clickCount == 1 ? .left : .right)
                
                cursorModel.state = .down(inputType: inputType, position: position)
                
            default: break
            }
            
        default: break
        }
    }
    
    public override func mouseUp(with event: NSEvent) {
        
        switch viewModel.state {
            
        case .scene(_, let cursorModel):
            
            switch cursorModel.state {
                
            case .down(let inputType, let startPosition),
                 .tracking(let inputType, let startPosition, _):
                
                let pointInView = convert(event.locationInWindow, from: nil)
                
                let position = CGPoint(x: pointInView.x, y: pointInView.y)
                
                cursorModel.state = .up(inputType: inputType, startPosition: startPosition, position: position)
                
            default: break
            }
            
        default: break
        }
    }
    
    public override func mouseDragged(with event: NSEvent) {
        
        switch viewModel.state {
            
        case .scene(_, let cursorModel):
            
            switch cursorModel.state {
                
            case .down(let inputType, let startPosition),
                 .tracking(let inputType, let startPosition, _):
                
                let pointInView = convert(event.locationInWindow, from: nil)
                
                let position = CGPoint(x: pointInView.x, y: pointInView.y)
                
                cursorModel.state = .tracking(inputType: inputType, startPosition: startPosition, position: position)
                
            default: break
            }
            
        default: break
        }
    }
}
