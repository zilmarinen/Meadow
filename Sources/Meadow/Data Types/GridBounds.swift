//
//  GridBounds.swift
//
//  Created by Zack Brown on 28/12/2020.
//

public struct GridBounds {
    
    public let start: Coordinate
    public let end: Coordinate
    
    public init(start: Coordinate, end: Coordinate) {
        
        let minimumX = min(start.x, end.x)
        let minimumZ = min(start.z, end.z)
        let maximumX = max(start.x, end.x)
        let maximumZ = max(start.z, end.z)
        
        self.start = Coordinate(x: minimumX, y: start.y, z: minimumZ)
        self.end = Coordinate(x: maximumX, y: end.y, z: maximumZ)
    }
}

extension GridBounds {
    
    static func == (lhs: GridBounds, rhs: GridBounds) -> Bool {
        
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
