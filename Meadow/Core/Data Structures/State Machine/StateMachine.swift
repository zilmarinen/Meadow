//
//  StateMachine.swift
//  Meadow-iOS
//
//  Created by Zack Brown on 05/07/2019.
//  Copyright © 2019 Script Orchard. All rights reserved.
//

import Foundation

public class StateMachine<StateType: State>: CustomStringConvertible {
    
    public typealias Transition = (_ from: StateType?, _ to: StateType) -> Void
    
    private var didTransition: Transition!
    
    private var _state: StateType! {
        
        didSet {
            
            history?.append(_state)
            
            if let size = history?.count, size > historySize {
                
                history?.remove(at: 0)
            }
            
            didTransition(oldValue, _state)
        }
    }
    
    public var historySize: Int = 0 {
        
        didSet {
            
            if oldValue == 0 && historySize > 0 {
                
                history = [state]
                
            } else if historySize == 0 {
                
                history = nil
            }
        }
    }
    
    public private(set) var history: [StateType]?
    
    public var state: StateType {
        
        get {
            
            return _state
        }
        
        set {
            
            switch _state.shouldTransition(to: newValue) {
                
            case .continue:
                
                _state = newValue
                
            case .redirect(let redirectState):
                
                _state = newValue
                
                self.state = redirectState
                
            case .abort: break;
            }
        }
    }
    
    
    public init(_ initialState: StateType, transition: @escaping Transition) {
        
        _state = initialState
        
        didTransition = transition
        
        didTransition(nil, _state)
    }
    
    public var description: String {
        
        if let history = history {
            
            let string = history.reversed().map { "\t\(String(describing: $0))" }.joined(separator: "\n")
            
            return "StateMachine<\(type(of: StateType.self))> { history = \n\(string)\n}"
            
        }
        
        return "StateMachine<\(type(of: StateType.self))> { state = \(state) }"
    }
}
