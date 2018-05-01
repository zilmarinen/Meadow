//
//  Volume.swift
//  Meadow
//
//  Created by Zack Brown on 30/04/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import SceneKit

public struct Volume {
    
    let coordinate: Coordinate
    let size: Size
}

extension Volume: Hashable {
    
    public static func == (lhs: Volume, rhs: Volume) -> Bool {
        
        return lhs.coordinate == rhs.coordinate && lhs.size == rhs.size
    }
    
    public var hashValue: Int {
        
        return coordinate.x ^ coordinate.y ^ coordinate.z ^ size.width ^ size.height ^ size.depth
    }
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
