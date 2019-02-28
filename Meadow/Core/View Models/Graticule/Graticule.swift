//
//  Graticule.swift
//  Meadow
//
//  Created by Zack Brown on 25/02/2019.
//  Copyright © 2019 Script Orchard. All rights reserved.
//

import THRUtilities

extension SceneView {
    
    public enum GraticuleState: State {
        
        case down(position: Coordinate, closest: (corner: GridCorner, edge: GridEdge, polytope: Polytope), inputType: SceneView.CursorState.InputType)
        case tracking(position: (start: Coordinate, end: Coordinate), closest: (corner: GridCorner, edge: GridEdge, polytope: Polytope), yOffset: Int, inputType: SceneView.CursorState.InputType)
        case up(position: (start: Coordinate, end: Coordinate), closest: (corner: GridCorner, edge: GridEdge, polytope: Polytope), yOffset: Int, inputType: SceneView.CursorState.InputType)
        
        public func shouldTransition(to newState: SceneView.GraticuleState) -> Should<SceneView.GraticuleState> {
            
            switch newState {
                
            case .up(let position, let closest, _, _):
                
                return .redirect(.tracking(position: position, closest: closest, yOffset: 0, inputType: .none))
                
            case .down(let position, let closest, let inputType):
                
                return .redirect(.tracking(position: (start: position, end: position), closest: closest, yOffset: 0, inputType: inputType))
                
            default: return .continue
            }
        }
    }
    
    public class Graticule: BaseViewModel<GraticuleState> {
        
        public init() {
            
            super.init(initialState: .tracking(position: (start: Coordinate.zero, end: Coordinate.zero), closest: (corner: .northWest, edge: .north, polytope: Polytope(x: 0, y0: 0, y1: 0, y2: 0, y3: 0, z: 0)), yOffset: 0, inputType: .none))
        }
    }
}

