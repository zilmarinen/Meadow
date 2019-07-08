//
//  StateObserver.swift
//  Meadow
//
//  Created by Zack Brown on 05/07/2019.
//  Copyright © 2019 Script Orchard. All rights reserved.
//

import Foundation

open class StateObserver<ViewState: State>: NSObject, HandlesStateChanges {
    
    public typealias T = ViewState
    public typealias StateCallback = (_ from: ViewState?, _ to: ViewState) -> ()
    public typealias CallbackReference = UUID
    
    public private(set) var stateMachine: StateMachine<ViewState>!
    
    private var callbacks: [CallbackReference: StateCallback] = [:]
    
    open var state: ViewState {
        
        get { return stateMachine.state }
        
        set { stateMachine.state = newValue }
    }
    
    public init(initialState: ViewState, callback: StateCallback? = nil) {
        
        super.init()
        
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
    
    open func stateDidChange(from previousState: ViewState?, to currentState: ViewState)  { }
    
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
