//
//  SceneKitSceneStateObserver.swift
//  Meadow
//
//  Created by Zack Brown on 20/07/2019.
//  Copyright © 2019 Script Orchard. All rights reserved.
//

extension SceneKitScene {
    
    public enum SceneState: State {
        
        case empty
        case loading(map: Map)
        case scene(world: World)
        
        public func shouldTransition(to newState: SceneState) -> Should<SceneState> {
            
            return .continue
        }
    }
    
    public class SceneKitSceneStateObserver: StateObserver<SceneState> {
        
        public func load(map: Map) {
            
            switch self.state {
                
            case .empty,
                 .loading,
                 .scene:
                
                self.state = .loading(map: map)
                
            default: fatalError("Invalid state transition")
            }
        }
        
        public func show(world: World) {
            
            switch self.state {
                
            case .empty,
                 .loading,
                 .scene:
                
                self.state = .scene(world: world)
                
            default: fatalError("Invalid state transition")
            }
        }
    }
}
