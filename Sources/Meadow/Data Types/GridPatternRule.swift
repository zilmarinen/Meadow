//
//  GridPatternRule.swift
//  
//  Created by Zack Brown on 13/11/2020.
//

import Foundation

struct GridPatternRule {
    
    var left: Int?
    var center: Int?
    var right: Int?
}

extension GridPatternRule {
    
    func equals(rule: GridPatternRule) -> Bool {
        
        return left == rule.right && center == rule.center && right == rule.left
    }
    
    func matches(rule: GridPatternRule) -> Bool {
        
        return (left == rule.right || left == nil || rule.right == nil) &&
                (center == rule.center || center == nil || rule.center == nil) &&
                (right == rule.left || right == nil || rule.left == nil)
    }
}
