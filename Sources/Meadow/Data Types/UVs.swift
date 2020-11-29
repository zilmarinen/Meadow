//
//  UVs.swift
//
//  Created by Zack Brown on 26/11/2020.
//

import CoreGraphics

struct UVs: Codable, Equatable {
    
    let start: CGPoint
    let end: CGPoint
    
    var uvs: [CGPoint] {
        
        return [CGPoint(x: end.x, y: end.y),
                CGPoint(x: start.x, y: end.y),
                CGPoint(x: start.x, y: start.y),
                CGPoint(x: end.x, y: start.y)]
    }
}
