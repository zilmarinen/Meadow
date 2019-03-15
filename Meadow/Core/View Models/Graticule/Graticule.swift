//
//  Graticule.swift
//  Meadow
//
//  Created by Zack Brown on 25/02/2019.
//  Copyright © 2019 Script Orchard. All rights reserved.
//

import THRUtilities

extension SceneView {
    
    public typealias SceneViewHit = (coordinate: Coordinate, corner: GridCorner, edge: GridEdge, polytope: Polytope)
    
    public enum GraticuleState: State {
        
        case down(start: SceneViewHit, inputType: SceneView.CursorState.InputType)
        case tracking(start: SceneViewHit, end: SceneViewHit, yOffset: Int, inputType: SceneView.CursorState.InputType)
        case up(start: SceneViewHit, end: SceneViewHit, yOffset: Int, inputType: SceneView.CursorState.InputType)
        
        public func shouldTransition(to newState: SceneView.GraticuleState) -> Should<SceneView.GraticuleState> {
            
            switch newState {
                
            case .up(let start, let end, _, _):
                
                return .redirect(.tracking(start: start, end: end, yOffset: 0, inputType: .none))
                
            case .down(let start, let inputType):
                
                return .redirect(.tracking(start: start, end: start, yOffset: 0, inputType: inputType))
                
            default: return .continue
            }
        }
    }
    
    public class Graticule: BaseViewModel<GraticuleState> {
        
        public init() {
            
            let hit = (Coordinate.zero, GridCorner.northWest, GridEdge.north, Polytope(x: 0, y0: 0, y1: 0, y2: 0, y3: 0, z: 0))
            
            super.init(initialState: .tracking(start: hit, end: hit, yOffset: 0, inputType: .none))
        }
    }
}

