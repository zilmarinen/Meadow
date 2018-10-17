//
//  CornerGraticule.swift
//  Meadow-iOS
//
//  Created by Zack Brown on 17/10/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import SceneKit
import THRUtilities

extension SceneView {
    
    public enum CornerGraticuleState: State {
        
        case idle
        
        public func shouldTransition(to newState: SceneView.CornerGraticuleState) -> Should<SceneView.CornerGraticuleState> {
            
            return .continue
        }
    }
    
    public class CornerGraticule: BaseViewModel<CornerGraticuleState> {
        
        public init() {
            
            super.init(initialState: .idle)
        }
    }
}
