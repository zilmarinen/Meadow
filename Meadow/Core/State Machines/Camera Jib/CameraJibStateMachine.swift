//
//  CameraJibStateMachine.swift
//  Meadow-iOS
//
//  Created by Zack Brown on 07/06/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import SceneKit

extension CameraJib {

    /*!
     @enum CameraState
     @abstract Defines all possible allowed states of the camera and how to handle any transitions between states.
     */
    public enum CameraState: State {
        
        case focus(SCNVector3, GridEdge, MDWFloat)
        
        /*!
         @method shouldTransition:to
         @abstract Defines the logic for transitioning between states.
         */
        public func shouldTransition(to newState: CameraState) -> Should<CameraState> {
            
            return .continue
        }
    }
    
    /*!
     @class CameraJibStateMachine
     @abstract Handles the transitions between states.
     */
    public class CameraJibStateMachine: StateMachine<CameraState> {
    
    }
}
