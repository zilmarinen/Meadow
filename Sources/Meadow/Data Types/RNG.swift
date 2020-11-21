//
//  RNG.swift
//
//  Created by Zack Brown on 16/11/2020.
//

import Foundation
import GameplayKit

class RNG: RandomNumberGenerator {
    
    let seed: UInt64
    
    let generator: GKMersenneTwisterRandomSource
    
    init(seed: UInt64) {
        
        self.seed = seed
        self.generator = GKMersenneTwisterRandomSource(seed: seed)
    }
    
    func next() -> UInt64 {
        
        return UInt64(abs(generator.nextInt()))
    }
}
