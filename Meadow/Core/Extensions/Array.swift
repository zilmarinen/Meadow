//
//  Array.swift
//  Meadow
//
//  Created by Zack Brown on 20/07/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

extension Array where Element == Int {
    
    func wind(steps: Int, slices: Int) -> [[Int]] {
        
        var result: [[Int]] = []
        
        let step = (steps - 1)
        
        for index in 0..<slices {
            
            let range = Range((index * step)...((index * step) + step))
            
            result.append(range.map { return self[($0 % count)] })
        }
        
        return result
    }
}
