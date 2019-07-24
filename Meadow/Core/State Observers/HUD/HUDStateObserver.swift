//
//  HUDStateObserver.swift
//  Meadow
//
//  Created by Zack Brown on 20/07/2019.
//  Copyright © 2019 Script Orchard. All rights reserved.
//

extension SceneKitView {
    
    public enum HUDState: State {
        
        case empty
        case scene(scene: SpriteKitScene)
        
        public func shouldTransition(to newState: HUDState) -> Should<HUDState> {
            
            return .continue
        }
    }
    
    public class HUDStateObserver: StateObserver<HUDState> {
        
        public func clear() {
            
            switch self.state {
                
            case .scene:
                
                self.state = .empty
                
            default: break
            }
        }
        
        public func load(scene: SpriteKitScene) {
            
            switch self.state {
                
            case .empty,
                 .scene:
                
                self.state = .scene(scene: scene)
            }
        }
    }
}

