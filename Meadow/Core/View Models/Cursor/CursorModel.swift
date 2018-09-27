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
        
        case down(inputType: InputType, position: CGPoint)
        case tracking(inputType: InputType, startPosition: CGPoint, position: CGPoint)
        case up(inputType: InputType, startPosition: CGPoint, position: CGPoint)
        case idle
        
        public func shouldTransition(to newState: CursorState) -> Should<CursorState> {
        
            if case .up = newState {
                
                return .redirect(.idle)
            }
            
            return .continue
        }
    }
    
    public class CursorModel: BaseViewModel<CursorState> {
        
        public init() {
            
            super.init(initialState: .idle)
        }
    }
}
