//
//  SpriteButton_iOS.swift
//  Meadow-iOS
//
//  Created by Zack Brown on 03/05/2019.
//  Copyright © 2019 Script Orchard. All rights reserved.
//

extension SpriteButton {
    
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        super.touchesBegan(touches, with: event)
        
        guard let scene = scene else { return }
        
        switch viewModel.state {
            
        case .idle:
            
            guard let touch = touches.first else { break }
            
            let point = touch.location(in: scene)
            
            let inputType: ViewState.InputType = (touch.tapCount == 1 ? .left : .right)
            
            self.viewModel.state = .down(position: (start: point, end: point), inputType: inputType)
            
        default: break
        }
    }
    
    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    
        super.touchesEnded(touches, with: event)
        
        guard let scene = scene else { return }
        
        switch viewModel.state {
            
        case .down(let position, let inputType),
             .tracking(let position, let inputType):
            
            guard let touch = touches.first else { break }
            
            let point = touch.location(in: scene)
            
            if contains(point) {
            
                self.viewModel.state = .upInside(position: (start: position.start, end: point), inputType: inputType)
            }
            else {
                
                self.viewModel.state = .up(position: (start: position.start, end: point), inputType: inputType)
            }
            
        default: break
        }
    }
    
    override public func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        super.touchesMoved(touches, with: event)
        
        guard let scene = scene else { return }
        
        switch viewModel.state {
            
        case .down(let position, let inputType),
             .tracking(let position, let inputType):
            
            guard let touch = touches.first else { break }
            
            let point = touch.location(in: scene)
            
            self.viewModel.state = .tracking(position: (start: position.start, end: point), inputType: inputType)
            
        default: break
        }
    }
}
