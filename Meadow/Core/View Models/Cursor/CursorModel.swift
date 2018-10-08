//
//  CursorModel.swift
//  Meadow-iOS
//
//  Created by Zack Brown on 19/09/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import SceneKit
import THRUtilities

extension SceneView {
    
    public enum CursorState: State {
        
        public enum InputType {
            
            case left
            case middle
            case right
        }
        
        case down(position: CGPoint, inputType: InputType)
        case tracking(position: CGPoint, inputType: InputType, startPosition: CGPoint)
        case up(position: CGPoint, inputType: InputType, startPosition: CGPoint)
        case idle(position: CGPoint)
        
        public func shouldTransition(to newState: CursorState) -> Should<CursorState> {
        
            switch newState {
                
            case .up(let position, _, _):
                
                return .redirect(.idle(position: position))
                
            default:
                
                return .continue
            }
        }
    }
    
    public class CursorModel: BaseViewModel<CursorState> {
        
        public var tracksIdleEvents: Bool = false
        
        public init() {
            
            super.init(initialState: .idle(position: CGPoint.zero))
        }
    }
}
