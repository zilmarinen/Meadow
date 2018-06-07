//
//  StateMachine.swift
//  Meadow-iOS
//
//  Created by Zack Brown on 07/06/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

/*!
 @protocol State
 @abstract Determines valid state transitions.
 */
public protocol State {
    
    /// Determines valid state transitions.
    ///
    /// - Parameter newState: The proposed state to transition to.
    /// - Returns: whether the transition should be allowed, aborted, or redirected to another state.
    
    
    /*!
     @method shouldTransition:to
     @abstract Determines whether the transition should be allowed.
     */
    func shouldTransition(to newState: Self) -> Should<Self>
}

/*!
 @enum Should
 @abstract Represents the action to be taken when transitioning between states.
 */
public enum Should<T> {
    
    case `continue`
    case abort
    case redirect(T)
}

/*!
 @class StateMachine
 @abstract A simple state machine.
 */
public class StateMachine<StateType: State> {
    
    public typealias Transition = (_ from: StateType?, _ to: StateType) -> Void
    
    /*!
     @var didTransition
     @abstract Callback block to be invoked when transitioning between states.
     */
    private var didTransition: Transition!
    
    /*!
     @var _state
     @abstract Private state to handle conditional state transitions.
     */
    private var _state: StateType! {
        
        didSet {
            
            didTransition(oldValue, _state)
        }
    }
    
    /*!
     @var state
     @abstract Public getter and setter for the current state.
     */
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
    
    /*!
     @method init:initialState:transition
     @abstract Create and initialise a state machine with the specified state.
     @param initialState The state to begin in.
     @param transition A callback block to be invoked when transitioning between states.
     */
    public init(_ initialState: StateType, transition: @escaping Transition) {
        _state = initialState
        didTransition = transition
        didTransition(nil, _state)
    }
}

