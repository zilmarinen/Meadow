//
//  Volume.swift
//  Meadow
//
//  Created by Zack Brown on 07/02/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

struct Volume {
    
    public let coordinate: Coordinate
    public let size: Size
}

extension Volume {
    
    public static var zero = Volume(coordinate: .zero, size: .zero)
}

extension Volume {
    
    func contains(coordinate other: Coordinate) -> Bool {
        
        if other.x >= coordinate.x && other.x < (coordinate.x + size.width) &&
            other.y >= coordinate.y && other.y < (coordinate.y + size.height) &&
            other.z >= coordinate.z && other.z < (coordinate.z + size.depth) {
            
            return true
        }
        
        return false
    }
}

extension Volume: Equatable {
    
    static func == (lhs: Volume, rhs: Volume) -> Bool {
        
        return lhs.coordinate == rhs.coordinate && lhs.size == rhs.size
    }
}

extension Volume: Hashable {
    
    func hash(into hasher: inout Hasher) {
        
        hasher.combine(coordinate)
        hasher.combine(size)
    }
}
