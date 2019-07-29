//
//  SpriteKitSceneStateObserver.swift
//  Meadow
//
//  Created by Zack Brown on 20/07/2019.
//  Copyright © 2019 Script Orchard. All rights reserved.
//

extension SpriteKitScene {
    
    public enum SceneState: State {
        
        case empty
        case alert(controller: AlertController)
        
        public func shouldTransition(to newState: SceneState) -> Should<SceneState> {
            
            return .continue
        }
    }
    
    public class SpriteKitSceneStateObserver: StateObserver<SceneState> {
        
        public func present(alert: AlertController) {
            
            switch state {
                
            case .empty:
                
                self.state = .alert(controller: alert)
                
            default: break
            }
        }
        
        public func dismiss() {
            
            switch state {
                
            case .alert(let controller):
                
                self.state = .empty
                
            default: break
            }
        }
    }
}
