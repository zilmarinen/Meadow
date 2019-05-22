//
//  Cursor.swift
//  Meadow
//
//  Created by Zack Brown on 19/09/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import SceneKit
import THRUtilities

extension SceneKitView {
    
    public enum CursorState: State {
        
        public enum InputType {
            
            case none
            case left
            case middle
            case right
        }
        
        case down(position: (start: CGPoint, end: CGPoint), inputType: InputType)
        case tracking(position: (start: CGPoint, end: CGPoint), inputType: InputType)
        case up(position: (start: CGPoint, end: CGPoint), inputType: InputType)
        case idle(position: CGPoint)
        
        public func shouldTransition(to newState: CursorState) -> Should<CursorState> {
        
            switch newState {
                
            case .up(let position, _):
                
                return .redirect(.idle(position: position.end))
                
            case .down(let position, let inputType):
                
                return .redirect(.tracking(position: position, inputType: inputType))
                
            default: return .continue
            }
        }
    }
    
    public class Cursor: BaseViewModel<CursorState> {
        
        public var tracksIdleEvents: Bool = false
        
        public init() {
            
            super.init(initialState: .idle(position: CGPoint.zero))
        }
    }
}
