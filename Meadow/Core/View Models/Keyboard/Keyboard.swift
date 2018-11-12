//
//  Keyboard.swift
//  Meadow
//
//  Created by Zack Brown on 19/10/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import THRUtilities

extension SceneView {
    
    public enum KeyCode: UInt16 {
        
        case a = 0
        case s = 1
        case d = 2
        case z = 6
        case x = 7
        case q = 12
        case w = 13
        case e = 14
        case esc = 53
    }
    
    public enum KeyboardState: State {
        
        case idle
        case keyDown(key: KeyCode)
        case keysHeld(keys: Set<KeyCode>)
        case keyUp(key: KeyCode)
        
        public func shouldTransition(to newState: SceneView.KeyboardState) -> Should<SceneView.KeyboardState> {
            
            switch self {
                
            case .keysHeld(var keys):
                
                switch newState {
                    
                case .keyDown(let key):
                    
                    guard keys.insert(key).inserted else { return .abort }
                    
                    return .redirect(.keysHeld(keys: keys))
                    
                case .keyUp(let key):
                    
                    keys.remove(key)
                    
                    if keys.count > 0 {
                        
                        return .redirect(.keysHeld(keys: keys))
                    }
                    
                    return .redirect(.idle)
                    
                default: return .abort
                }
                
            default: return .continue
            }
        }
    }
    
    public class Keyboard: BaseViewModel<KeyboardState> {
        
        public init() {
            
            super.init(initialState: .idle)
        }
    }
}
