//
//  CameraJibModel.swift
//  Meadow
//
//  Created by Zack Brown on 07/06/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import SceneKit
import THRUtilities

extension CameraJib {

    public enum CameraState: State {
        
        case focus(vector: SCNVector3, edge: GridEdge, zoom: MDWFloat)
        
        public func shouldTransition(to newState: CameraState) -> Should<CameraState> {
            
            return .continue
        }
    }
    
    public class CameraJibModel: BaseViewModel<CameraState> {
    
        init() {
            
            super.init(initialState: .focus(vector: SCNVector3Zero, edge: .north, zoom: CameraJib.maximumZoomLevel))
        }
    }
}
