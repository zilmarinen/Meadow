//
//  Stopwatch.swift
//  Meadow
//
//  Created by Zack Brown on 26/04/2019.
//  Copyright © 2019 Script Orchard. All rights reserved.
//

import Foundation

public class Stopwatch {
    
    public let mark: TimeInterval
    public let duration: TimeInterval
    var delta: TimeInterval
    
    public var complete: Bool {
        
        return (mark + delta >= duration)
    }
    
    public init(duration: TimeInterval, mark: TimeInterval? = 0) {
        
        self.mark = mark ?? 0
        self.duration = duration
        self.delta = 0
    }
    
    public func advance(deltaTime: TimeInterval) -> Bool {
        
        self.delta += deltaTime
        
        return complete
    }
}

