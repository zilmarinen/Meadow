//
//  State.swift
//  Meadow-iOS
//
//  Created by Zack Brown on 05/07/2019.
//  Copyright © 2019 Script Orchard. All rights reserved.
//

import Foundation

public protocol State {
    
    func shouldTransition(to newState: Self) -> Should<Self>
}

public enum Should<T> {
    
    case `continue`, abort, redirect(T)
}
