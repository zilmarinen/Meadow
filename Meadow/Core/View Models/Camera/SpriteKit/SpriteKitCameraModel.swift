//
//  SpriteKitCameraModel.swift
//  Meadow
//
//  Created by Zack Brown on 09/05/2019.
//  Copyright © 2019 Script Orchard. All rights reserved.
//

import SpriteKit
import THRUtilities

extension SpriteKitCamera {
    
    public enum CameraState: State {
        
        case focus(point: CGPoint, zoom: MDWFloat)
        
        public func shouldTransition(to newState: SpriteKitCamera.CameraState) -> Should<SpriteKitCamera.CameraState> {
            
            return .continue
        }
    }
    
    public class SpriteKitCameraModel: BaseViewModel<CameraState> {
        
    }
}
