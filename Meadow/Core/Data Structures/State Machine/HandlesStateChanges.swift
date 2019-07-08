//
//  HandlesStateChanges.swift
//  Meadow
//
//  Created by Zack Brown on 05/07/2019.
//  Copyright © 2019 Script Orchard. All rights reserved.
//

import Foundation

public protocol HandlesStateChanges {
    
    associatedtype T: State
    
    func stateDidChange(from previousState: T?, to currentState: T)
}
