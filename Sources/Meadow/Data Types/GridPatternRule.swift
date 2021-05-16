//
//  GridPatternRule.swift
//
//  Created by Zack Brown on 19/03/2021.
//

public struct GridPatternRule<T: Codable & Equatable>: Codable, Equatable {
    
    var left: T
    var center: T
    var right: T
}

extension GridPatternRule {
    
    func matches(rule: Self) -> Bool {
        
        return left == rule.right && center == rule.center && right == rule.left
    }
}
