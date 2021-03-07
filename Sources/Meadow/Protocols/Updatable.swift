//
//  Updatable.swift
//
//  Created by Zack Brown on 03/11/2020.
//

import Foundation

public protocol Updatable {
    
    func update(delta: TimeInterval, time: TimeInterval)
}
