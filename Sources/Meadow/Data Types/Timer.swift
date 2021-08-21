//
//  Stopwatch.swift
//
//  Created by Zack Brown on 19/08/2021.
//

import Foundation

public class Stopwatch {

    public let duration: TimeInterval
    var elapsed: TimeInterval = 0

    public init(duration: TimeInterval) {

        self.duration = duration
    }

    public func integrate(delta: TimeInterval) -> Bool {

        elapsed += delta

        return elapsed >= duration
    }
}
