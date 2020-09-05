//
//  CameraObserver.swift
//  Meadow
//
//  Created by Zack Brown on 29/05/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

import SceneKit
import Terrace

extension Camera {
    
    public enum CameraState: State {
        
        case dolly(node: SCNNode)
        case focus(node: SCNNode)
        
        public func shouldTransition(to newState: Camera.CameraState) -> Should<Camera.CameraState> {
            
            return .continue
        }
    }
    
    public class CameraObserver: StateObserver<CameraState> {
        
        public func focus(node: SCNNode) {
            
            state = .focus(node: node)
        }
        
        public func focus(vector: SCNVector3) {
            
            let node = SCNNode()
            
            node.position = vector
            
            state = .focus(node: node)
        }
    }
}
