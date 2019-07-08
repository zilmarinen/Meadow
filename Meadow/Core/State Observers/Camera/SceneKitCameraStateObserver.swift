//
//  SceneKitCameraStateObserver.swift
//  Meadow
//
//  Created by Zack Brown on 07/06/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import SceneKit

extension SceneKitCamera {

    public enum CameraState: State {
        
        case idle
        case focus(node: SCNNode, edge: GridEdge, zoom: MDWFloat)
        
        public func shouldTransition(to newState: CameraState) -> Should<CameraState> {
            
            return .continue
        }
    }
    
    public class SceneKitCameraStateObserver: StateObserver<CameraState> {
    
    }
}
