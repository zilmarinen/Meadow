//
//  Keyboard.swift
//  Meadow
//
//  Created by Zack Brown on 19/10/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import THRUtilities

extension SceneKitView {
    
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
        
        public func shouldTransition(to newState: KeyboardState) -> Should<KeyboardState> {
            
            switch self {
            
            case .idle:
                
                switch newState {
                    
                case .keyDown(let key):
                    
                    return .redirect(.keysHeld(keys: [key]))
                
                default: return .abort
                }
                
            case .keysHeld(var keys):
                
                switch newState {
                    
                case .idle:
                    
                    return (keys.count > 0 ? .redirect(.keysHeld(keys: keys)) : .continue)
                    
                case .keyDown(let key):
                    
                    keys.insert(key)
                    
                    return (keys.count > 0 ? .redirect(.keysHeld(keys: keys)) : .redirect(.idle))
                
                case .keyUp(let key):
                    
                    keys.remove(key)
                    
                    return (keys.count > 0 ? .redirect(.keysHeld(keys: keys)) : .redirect(.idle))
                    
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
