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
            
        case .scene(let meadow):
            
            guard meadow.input.cursor.tracksIdleEvents else { break }
            
            switch meadow.input.cursor.state {
                
            case .idle:
                
                let pointInView = convert(event.locationInWindow, from: nil)
                
                let position = CGPoint(x: pointInView.x, y: pointInView.y)
                
                meadow.input.cursor.state = .idle(position: position)
                
            default: break
            }
            
        default: break
        }
    }
}

extension SceneView {
    
    func mouseDown(event: NSEvent, inputType: CursorState.InputType) {
        
        switch viewModel.state {
            
        case .scene(let meadow):
            
            switch meadow.input.cursor.state {
                
            case .idle:
                
                let pointInView = convert(event.locationInWindow, from: nil)
                
                let point = CGPoint(x: pointInView.x, y: pointInView.y)
                
                meadow.input.cursor.state = .down(position: (start: point, end: point), inputType: inputType)
                
            default: break
            }
            
        default: break
        }
    }
    
    func mouseUp(event: NSEvent, inputType: CursorState.InputType) {
     
        switch viewModel.state {
            
        case .scene(let meadow):
            
            switch meadow.input.cursor.state {
                
            case .down(let position, _),
                 .tracking(let position, _):
                
                let pointInView = convert(event.locationInWindow, from: nil)
                
                let point = CGPoint(x: pointInView.x, y: pointInView.y)
                
                meadow.input.cursor.state = .up(position: (start: position.start, end: point), inputType: inputType)
                
            default: break
            }
            
        default: break
        }
    }
    
    func mouseDragged(event: NSEvent, inputType: CursorState.InputType) {
        
        switch viewModel.state {
            
        case .scene(let meadow):
            
            switch meadow.input.cursor.state {
                
            case .down(let position, _),
                 .tracking(let position, _):
                
                let pointInView = convert(event.locationInWindow, from: nil)
                
                let point = CGPoint(x: pointInView.x, y: pointInView.y)
                
                meadow.input.cursor.state = .tracking(position: (start: position.start, end: point), inputType: inputType)
                
            default: break
            }
            
        default: break
        }
    }
}

extension SceneView {
    
    public override func keyDown(with event: NSEvent) {
        
        switch viewModel.state {
            
        case .scene(let meadow):
            
            guard let keyCode = KeyCode(rawValue: event.keyCode) else { break }
            
            switch meadow.input.keyboard.state {
                
            case .idle:
                
                meadow.input.keyboard.state = .keyDown(key: keyCode)
                
            case .keysHeld(let keys):
                
                guard !keys.contains(keyCode) else { break }
                
                meadow.input.keyboard.state = .keyDown(key: keyCode)
                
            default: break
            }
            
        default: break
        }
    }
    
    public override func keyUp(with event: NSEvent) {
        
        switch viewModel.state {
            
        case .scene(let meadow):
            
            guard let keyCode = KeyCode(rawValue: event.keyCode) else { break }
            
            meadow.input.keyboard.state = .keyUp(key: keyCode)
            
        default: break
        }
    }
}
