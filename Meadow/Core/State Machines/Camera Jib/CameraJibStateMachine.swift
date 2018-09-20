//
//  CameraJibStateMachine.swift
//  Meadow-iOS
//
//  Created by Zack Brown on 07/06/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import SceneKit

extension CameraJib {

    public enum CameraState: State {
        
        case focus(SCNVector3, GridEdge, MDWFloat)
        
        public func shouldTransition(to newState: CameraState) -> Should<CameraState> {
            
            return .continue
        }
    }
    
    public class CameraJibStateMachine: StateMachine<CameraState> {
    
    }
}
