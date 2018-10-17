//
//  TileGraticule.swift
//  Meadow
//
//  Created by Zack Brown on 08/10/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import SceneKit
import THRUtilities

extension SceneView {
    
    public enum TileGraticuleState: State {
        
        case idle
        case tracking(position: Coordinate, startPosition: Coordinate)
        
        public func shouldTransition(to newState: SceneView.TileGraticuleState) -> Should<SceneView.TileGraticuleState> {
            
            return .continue
        }
    }
    
    public class TileGraticule: BaseViewModel<TileGraticuleState> {
        
        public init() {
            
            super.init(initialState: .idle)
        }
    }
}
