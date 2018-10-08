//
//  GraticuleModel.swift
//  Meadow-iOS
//
//  Created by Zack Brown on 08/10/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import SceneKit
import THRUtilities

extension SceneView {
    
    public enum GraticuleState: State {
        
        case idle
        
        public func shouldTransition(to newState: SceneView.GraticuleState) -> Should<SceneView.GraticuleState> {
            
            return .continue
        }
    }
    
    public class GraticuleModel: BaseViewModel<GraticuleState> {
        
        public init() {
            
            super.init(initialState: .idle)
        }
    }
}
