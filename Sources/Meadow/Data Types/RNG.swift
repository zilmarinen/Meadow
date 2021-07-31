//
//  RNG.swift
//
//  Created by Zack Brown on 16/11/2020.
//

import Foundation

public var rng = RNG(seed: 1337)

public struct RNG: RandomNumberGenerator {
    
    var seed: UInt64
    
    public init(seed: UInt64) {
        
        self.seed = seed
    }
    
    mutating public func next() -> UInt64 {
        
        seed &+= 0xA0761D6478BD642F
        
        let result = seed.multipliedFullWidth(by: seed ^ 0xE7037ED1A0B428DB)
        
        return result.high ^ result.low
    }
}
