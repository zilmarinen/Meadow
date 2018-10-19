//
//  EdgeGraticule.swift
//  Meadow-iOS
//
//  Created by Zack Brown on 17/10/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import SceneKit
import THRUtilities

extension SceneView {
    
    public enum EdgeGraticuleState: State {
        
        case idle
        case tracking(position: Coordinate, edge: GridEdge, yOffset: Int)
        
        public func shouldTransition(to newState: SceneView.EdgeGraticuleState) -> Should<SceneView.EdgeGraticuleState> {
            
            return .continue
        }
    }
    
    public class EdgeGraticule: BaseViewModel<EdgeGraticuleState> {
        
        public init() {
            
            super.init(initialState: .idle)
        }
    }
}
