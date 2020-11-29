//
//  PatternRule.swift
//  
//  Created by Zack Brown on 13/11/2020.
//

import Foundation

struct PatternRule {
    
    var left: Int?
    var center: Int?
    var right: Int?
}

extension PatternRule {
    
    func matches(rule: PatternRule) -> Bool {
        
        return (left == rule.right || left == nil || rule.right == nil) &&
                (center == rule.center || center == nil || rule.center == nil) &&
                (right == rule.left || right == nil || rule.left == nil)
    }
}
