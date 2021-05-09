//
//  ExampleView.swift
//
//  Created by Zack Brown on 07/05/2021.
//

import Cocoa
import Foundation
import Meadow

class ExampleView: SceneView, StartOption {
    
    public lazy var mouseObserver: MouseObserver = {
       
        return MouseObserver(initialState: .idle(position: .zero))
    }()

    public override func updateTrackingAreas() {
        
        super.updateTrackingAreas()
        
        let trackingArea = NSTrackingArea(rect: bounds, options: [NSTrackingArea.Options.mouseMoved, NSTrackingArea.Options.activeInKeyWindow], owner: self, userInfo: nil)
        
        addTrackingArea(trackingArea)
    }
}

extension ExampleView {
    
    public override func mouseDown(with event: NSEvent) {
        
        super.mouseDown(with: event)
        
        mouseDown(event: event, clickType: .left)
    }
    
    public override func rightMouseDown(with event: NSEvent) {
        
        super.rightMouseDown(with: event)
        
        mouseDown(event: event, clickType: .right)
    }
    
    public override func mouseUp(with event: NSEvent) {
        
        super.mouseUp(with: event)
        
        mouseUp(event: event, clickType: .left)
    }
    
    public override func rightMouseUp(with event: NSEvent) {
        
        super.rightMouseUp(with: event)
        
        mouseUp(event: event, clickType: .right)
    }
    
    public override func mouseDragged(with event: NSEvent) {
        
        super.mouseDragged(with: event)
        
        mouseDragged(event: event, clickType: .left)
    }
    
    public override func rightMouseDragged(with event: NSEvent) {
        
        super.rightMouseDragged(with: event)
        
        mouseDragged(event: event, clickType: .right)
    }
    
    public override func mouseMoved(with event: NSEvent) {
        
        super.mouseMoved(with: event)
        
        guard mouseObserver.tracksIdleEvents else { return }
        
        switch mouseObserver.state {
            
        case .idle:
            
            let point = convert(event.locationInWindow, from: nil)
            
            mouseObserver.state = .idle(position: point)
            
        default: break
        }
    }
    
    override func magnify(with event: NSEvent) {
        
        super.magnify(with: event)
        
        mouseZoom(event: event)
    }
}

extension ExampleView {
    
    func mouseDown(event: NSEvent, clickType: ExampleView.MouseState.ClickType) {
        
        switch mouseObserver.state {
            
        case .idle:
            
            let point = convert(event.locationInWindow, from: nil)
            
            mouseObserver.state = .down(position: ExampleView.MouseState.Click(start: point, end: point), clickType: clickType)
            
        default: break
        }
    }
    
    func mouseUp(event: NSEvent, clickType: ExampleView.MouseState.ClickType) {
     
        switch mouseObserver.state {
            
        case .down(let position, _),
             .tracking(let position, _):
            
            let point = convert(event.locationInWindow, from: nil)
            
            mouseObserver.state = .up(position: ExampleView.MouseState.Click(start: position.start, end: point), clickType: clickType)
            
        default: break
        }
    }
    
    func mouseDragged(event: NSEvent, clickType: ExampleView.MouseState.ClickType) {
        
        switch mouseObserver.state {
            
        case .down(let position, _),
             .tracking(let position, _):
            
            let point = convert(event.locationInWindow, from: nil)
            
            mouseObserver.state = .tracking(position: ExampleView.MouseState.Click(start: position.start, end: point), clickType: clickType)
            
        default: break
        }
    }
    
    func mouseZoom(event: NSEvent) {
        
        switch mouseObserver.state {
        
        case .idle:
            
            let point = convert(event.locationInWindow, from: nil)
            
            mouseObserver.state = .zoom(position: point, delta: Double(event.magnification))
            
        default: break
        }
    }
}
