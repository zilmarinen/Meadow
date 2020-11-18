//
//  TerrainTileRule.swift
//  
//  Created by Zack Brown on 13/11/2020.
//

import Foundation

struct TerrainTileRule {
    
    var left: TerrainTileType?
    var center: TerrainTileType?
    var right: TerrainTileType?
}

extension TerrainTileRule {
    
    func matches(rule: TerrainTileRule) -> Bool {
        
        return (left == rule.right || left == nil || rule.right == nil) &&
                (center == rule.center || center == nil || rule.center == nil) &&
                (right == rule.left || right == nil || rule.left == nil)
    }
}
