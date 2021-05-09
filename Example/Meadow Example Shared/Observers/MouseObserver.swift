//
//  MouseObserver.swift
//
//  Created by Zack Brown on 11/12/2020.
//

import Cocoa
import Meadow

extension ExampleView {
    
    public enum MouseState: State {
        
        public struct Click {
            
            let start: CGPoint
            let end: CGPoint
        }
        
        public enum ClickType {
            
            case none
            case left
            case middle
            case right
        }
        
        case down(position: Click, clickType: ClickType)
        case tracking(position: Click, clickType: ClickType)
        case up(position: Click, clickType: ClickType)
        case idle(position: CGPoint)
        case zoom(position: CGPoint, delta: Double)
        
        public func shouldTransition(to newState: MouseState) -> Should<MouseState> {
        
            switch newState {
                
            case .up(let position, _):
                
                return .redirect(.idle(position: position.end))
                
            case .down(let position, let clickType):
                
                return .redirect(.tracking(position: position, clickType: clickType))
                
            case .zoom(let position, _):
                
                return .redirect(.idle(position: position))
                
            default: return .continue
            }
        }
    }
    
    public class MouseObserver: StateObserver<MouseState> {
        
        public var tracksIdleEvents: Bool = false
    }
}
