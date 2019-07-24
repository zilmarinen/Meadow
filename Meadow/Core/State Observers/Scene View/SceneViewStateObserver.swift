//
//  SceneViewStateObserver.swift
//  Meadow
//
//  Created by Zack Brown on 26/09/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

extension SceneKitView {
    
    public enum ViewState: State {
        
        case empty(meadow: Meadow?)
        case scene(meadow: Meadow, scene: SceneKitScene)
        
        public func shouldTransition(to newState: ViewState) -> Should<ViewState> {
            
            return .continue
        }
    }
    
    public class SceneViewStateObserver: StateObserver<ViewState> {
        
    }
}
