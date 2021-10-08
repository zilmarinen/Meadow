//
//  MachineState.swift
//
//  Created by Zack Brown on 10/12/2020.
//

public protocol MachineState {
    
    func shouldTransition(to newState: Self) -> Should<Self>
}
