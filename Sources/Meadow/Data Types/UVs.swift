//
//  UVs.swift
//
//  Created by Zack Brown on 26/11/2020.
//

import CoreGraphics

public struct UVs: Codable, Equatable {
    
    let start: CGPoint
    let end: CGPoint
    
    public init(start: CGPoint, end: CGPoint) {
        
        self.start = start
        self.end = end
    }
    
    var uvs: [CGPoint] {
        
        return [CGPoint(x: end.x, y: end.y),
                CGPoint(x: start.x, y: end.y),
                CGPoint(x: start.x, y: start.y),
                CGPoint(x: end.x, y: start.y)]
    }
}
