//
//  CursorStateMachine.swift
//  Meadow-iOS
//
//  Created by Zack Brown on 19/09/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import SceneKit

extension Meadow {
    
    public enum CursorState: State {
        
        public enum InputType {
            
            case left
            case middle
            case right
        }
        
        case down(type: InputType, position: SCNVector3)
        case tracking(type: InputType, position: SCNVector3, startPosition: SCNVector3)
        case up(type: InputType, position: SCNVector3)
        case idle
        
        public func shouldTransition(to newState: Meadow.CursorState) -> Should<Meadow.CursorState> {
        
            return .continue
        }
    }
    
    public class CursorStateMachine: StateMachine<CursorState> {
        
    }
}
