//
//  SpriteButtonViewModel.swift
//  Meadow
//
//  Created by Zack Brown on 03/05/2019.
//  Copyright © 2019 Script Orchard. All rights reserved.
//

import THRUtilities

extension SpriteButton {
    
    public enum ViewState: State {
        
        public enum InputType {
            
            case none
            case left
            case middle
            case right
        }
        
        case down(position: (start: CGPoint, end: CGPoint), inputType: InputType)
        case tracking(position: (start: CGPoint, end: CGPoint), inputType: InputType)
        case up(position: (start: CGPoint, end: CGPoint), inputType: InputType)
        case upInside(position: (start: CGPoint, end: CGPoint), inputType: InputType)
        case idle
        
        public func shouldTransition(to newState: ViewState) -> Should<ViewState> {
            
            switch newState {
                
            case .up,
                 .upInside:
                
                return .redirect(.idle)
                
            case .down(let position, let inputType):
                
                return .redirect(.tracking(position: position, inputType: inputType))
                
            default: return .continue
            }
        }
    }
    
    public class SpriteButtonViewModel: BaseViewModel<ViewState> {
        
    }
}
