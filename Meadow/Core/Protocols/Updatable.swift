//
//  Updatable.swift
//  Meadow
//
//  Created by Zack Brown on 07/02/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

import Foundation

protocol Updatable {
    
    func update(delta: TimeInterval, time: TimeInterval)
}
