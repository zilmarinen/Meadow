//
//  GridBounds.swift
//
//  Created by Zack Brown on 28/12/2020.
//

import Foundation

public struct GridBounds: Equatable {
    
    public var size: CGSize { CGSize(width: abs(start.x - end.x) + 1, height: abs(start.z - end.z) + 1) }
    
    public let start: Coordinate
    public let end: Coordinate
    
    public init(start: Coordinate, end: Coordinate) {
        
        self.start = Coordinate.minimum(lhs: start, rhs: end)
        self.end = Coordinate.maximum(lhs: start, rhs: end)
    }
    
    public init(aligned coordinate: Coordinate, size: Int) {
        
        let x = Int(floor(Float(coordinate.x) / Float(size))) * size
        let z = Int(floor(Float(coordinate.z) / Float(size))) * size
        
        self.init(start: Coordinate(x: x, y: 0, z: z), end: Coordinate(x: x + (size - 1), y: 0, z: z + (size - 1)))
    }
    
    init(nodes: [Coordinate]) {
        
        var minimum = Coordinate.infinity
        var maximum = -Coordinate.infinity
        
        for node in nodes {
            
            minimum = Coordinate.minimum(lhs: minimum, rhs: node)
            maximum = Coordinate.maximum(lhs: maximum, rhs: node)
        }
        
        self.start = minimum
        self.end = maximum
    }
}

extension GridBounds {
    
    public static func == (lhs: GridBounds, rhs: GridBounds) -> Bool {
        
        return lhs.start == rhs.start && lhs.end == rhs.end
    }
}

extension GridBounds {
    
    public func enumerate(y: Int, block: ((Coordinate) -> Void)) {
        
        for x in start.x...end.x {
                            
            for z in start.z...end.z {
                
                block(Coordinate(x: x, y: y, z: z))
            }
        }
    }
}

extension GridBounds {
    
    public func contains(coordinate: Coordinate) -> Bool {
        
        guard coordinate.x >= start.x && coordinate.x <= end.x &&
                coordinate.z >= start.z && coordinate.z <= end.z  else { return false }
        
        return true
    }
}
