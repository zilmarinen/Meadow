//
//  StateObserver.swift
//
//  Created by Zack Brown on 10/12/2020.
//

import Foundation

open class StateObserver<ObservableState: State>: StateHandler {
    
    public typealias T = ObservableState
    public typealias StateCallback = (_ from: ObservableState?, _ to: ObservableState) -> ()
    public typealias CallbackReference = UUID
    
    public private(set) var stateMachine: StateMachine<ObservableState>!
    
    private var callbacks: [CallbackReference: StateCallback] = [:]
    
    open var state: ObservableState {
        
        get { return stateMachine.state }
        
        set { stateMachine.state = newValue }
    }
    
    public init(initialState: ObservableState, callback: StateCallback? = nil) {
        
        stateMachine = StateMachine(initialState) { [weak self] previous, current in
            
            guard let strongSelf = self else { return }
            
            strongSelf.callbacks.forEach { $0.value(previous, current) }
        }
        
        subscribe { [weak self] from, to in
            
            guard let strongSelf = self else { return }
            
            strongSelf.stateDidChange(from: from, to: to)
        }
        
        if let callback = callback { subscribe(callback) }
    }
    
    open func stateDidChange(from previousState: ObservableState?, to currentState: ObservableState)  { }
    
    @discardableResult public func subscribe(_ callback: @escaping StateCallback) -> CallbackReference {
        
        let reference = CallbackReference()
        
        callbacks[reference] = callback
        
        callback(nil, state)
        
        return reference
    }
    
    public func unsubscribe(_ reference: CallbackReference) {
        
        callbacks.removeValue(forKey: reference)
    }
}
