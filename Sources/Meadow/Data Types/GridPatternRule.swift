//
//  GridPatternRule.swift
//
//  Created by Zack Brown on 19/03/2021.
//

public struct GridPatternRule {
    
    var left: Bool
    var center: Bool
    var right: Bool
}

extension GridPatternRule {
    
    func matches(rule: GridPatternRule) -> Bool {
        
        return left == rule.right && center == rule.center && right == rule.left
    }
}
