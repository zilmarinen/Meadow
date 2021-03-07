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
        
        /*return [CGPoint(x: end.x, y: end.y),
                CGPoint(x: start.x, y: end.y),
                CGPoint(x: start.x, y: start.y),
                CGPoint(x: end.x, y: start.y)]*/
        
        return [CGPoint(x: start.x, y: end.y),
                CGPoint(x: end.x, y: end.y),
                CGPoint(x: end.x, y: start.y),
                CGPoint(x: start.x, y: start.y)]
    }
}

extension Array where Element == CGPoint {
    
    func average() -> CGPoint {
        
        guard count > 0 else { return .zero }
        
        var x: CGFloat = 0.0
        var y: CGFloat = 0.0
        
        for i in 0..<count {
            
            let point = self[i]
            
            x += point.x
            y += point.y
        }
        
        return CGPoint(x: x / CGFloat(count), y: y / CGFloat(count))
    }
}
