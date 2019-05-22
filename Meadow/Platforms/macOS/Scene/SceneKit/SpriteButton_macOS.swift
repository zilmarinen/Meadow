//
//  SpriteButton_macOS.swift
//  Meadow-macOS
//
//  Created by Zack Brown on 03/05/2019.
//  Copyright © 2019 Script Orchard. All rights reserved.
//

extension SpriteButton {
    
    public override func mouseDown(with event: NSEvent) {
        
        super.mouseDown(with: event)
        
        mouseDown(event: event, inputType: .left)
    }
    
    public override func rightMouseDown(with event: NSEvent) {
        
        super.rightMouseDown(with: event)
        
        mouseDown(event: event, inputType: .right)
    }
    
    public override func mouseUp(with event: NSEvent) {
        
        super.mouseUp(with: event)
        
        mouseUp(event: event, inputType: .left)
    }
    
    public override func rightMouseUp(with event: NSEvent) {
        
        super.rightMouseUp(with: event)
        
        mouseUp(event: event, inputType: .right)
    }
    
    public override func mouseDragged(with event: NSEvent) {
        
        super.mouseDragged(with: event)
        
        mouseDragged(event: event, inputType: .left)
    }
    
    public override func rightMouseDragged(with event: NSEvent) {
        
        super.rightMouseDragged(with: event)
        
        mouseDragged(event: event, inputType: .right)
    }
}

extension SpriteButton {
    
    func mouseDown(event: NSEvent, inputType: ViewState.InputType) {
        
        guard let scene = scene else { return }
        
        switch viewModel.state {
            
        case .idle:
            
            let point = event.location(in: scene)
            
            self.viewModel.state = .down(position: (start: point, end: point), inputType: inputType)
            
        default: break
        }
    }
    
    func mouseUp(event: NSEvent, inputType: ViewState.InputType) {
        
        guard let scene = scene else { return }
        
        switch viewModel.state {
            
        case .down(let position, _),
             .tracking(let position, _):
            
            let point = event.location(in: scene)
            
            if contains(point) {
            
                self.viewModel.state = .upInside(position: (start: position.start, end: point), inputType: inputType)
            }
            else {
                
                self.viewModel.state = .up(position: (start: position.start, end: point), inputType: inputType)
            }
            
        default: break
        }
    }
    
    func mouseDragged(event: NSEvent, inputType: ViewState.InputType) {
        
        guard let scene = scene else { return }
        
        switch viewModel.state {
            
        case .down(let position, _),
             .tracking(let position, _):
            
            let point = event.location(in: scene)
            
            self.viewModel.state = .tracking(position: (start: position.start, end: point), inputType: inputType)
            
        default: break
        }
    }
}
