//
//  SceneView_macOS.swift
//  Meadow
//
//  Created by Zack Brown on 26/09/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import SceneKit

extension SceneView {
    
    public override func updateTrackingAreas() {
        
        super.updateTrackingAreas()
        
        let trackingArea = NSTrackingArea(rect: self.frame, options: [NSTrackingArea.Options.mouseMoved, NSTrackingArea.Options.activeInKeyWindow], owner: self, userInfo: nil)
        
        self.addTrackingArea(trackingArea)
    }
    
    public override func mouseDown(with event: NSEvent) {
        
        mouseDown(event: event, inputType: .left)
    }
    
    public override func rightMouseDown(with event: NSEvent) {
        
        mouseDown(event: event, inputType: .right)
    }
    
    public override func mouseUp(with event: NSEvent) {
        
        mouseUp(event: event, inputType: .left)
    }
    
    public override func rightMouseUp(with event: NSEvent) {
        
        mouseUp(event: event, inputType: .right)
    }
    
    public override func mouseDragged(with event: NSEvent) {
        
        mouseDragged(event: event, inputType: .left)
    }
    
    public override func rightMouseDragged(with event: NSEvent) {
        
        mouseDragged(event: event, inputType: .right)
    }
    
    public override func mouseMoved(with event: NSEvent) {
        
        switch viewModel.state {
            
        case .scene(_, let cursorModel):
            
            guard cursorModel.tracksIdleEvents else { break }
            
            switch cursorModel.state {
                
            case .idle:
                
                let pointInView = convert(event.locationInWindow, from: nil)
                
                let position = CGPoint(x: pointInView.x, y: pointInView.y)
                
                cursorModel.state = .idle(position: position)
                
            default: break
            }
            
        default: break
        }
    }
}

extension SceneView {
    
    func mouseDown(event: NSEvent, inputType: CursorState.InputType) {
        
        switch viewModel.state {
            
        case .scene(_, let cursorModel):
            
            switch cursorModel.state {
                
            case .idle:
                
                let pointInView = convert(event.locationInWindow, from: nil)
                
                let position = CGPoint(x: pointInView.x, y: pointInView.y)
                
                cursorModel.state = .down(position: position, inputType: inputType)
                
            default: break
            }
            
        default: break
        }
    }
    
    func mouseUp(event: NSEvent, inputType: CursorState.InputType) {
     
        switch viewModel.state {
            
        case .scene(_, let cursorModel):
            
            switch cursorModel.state {
                
            case .down(let startPosition, _),
                 .tracking(_, _, let startPosition):
                
                let pointInView = convert(event.locationInWindow, from: nil)
                
                let position = CGPoint(x: pointInView.x, y: pointInView.y)
                
                cursorModel.state = .up(position: position, inputType: inputType, startPosition: startPosition)
                
            default: break
            }
            
        default: break
        }
    }
    
    func mouseDragged(event: NSEvent, inputType: CursorState.InputType) {
        
        switch viewModel.state {
            
        case .scene(_, let cursorModel):
            
            switch cursorModel.state {
                
            case .down(let startPosition, _),
                 .tracking(_, _, let startPosition):
                
                let pointInView = convert(event.locationInWindow, from: nil)
                
                let position = CGPoint(x: pointInView.x, y: pointInView.y)
                
                cursorModel.state = .tracking(position: position, inputType: inputType, startPosition: startPosition)
                
            default: break
            }
            
        default: break
        }
    }
}
