//
//  StateHandler.swift
//
//  Created by Zack Brown on 10/12/2020.
//

public protocol StateHandler {
    
    associatedtype T: State
    
    func stateDidChange(from previousState: T?, to currentState: T)
}
