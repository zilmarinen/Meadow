//
//  LayerCorners.swift
//  Meadow
//
//  Created by Zack Brown on 07/02/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

import Pasture

public class LayerCorners: Codable, Equatable {
    
    struct Constants {
        
        static let maximumPitch = 2
    }
    
    public enum Anchor: Int, Codable {
        
        case left
        case right
        case centre
    }
    
    public struct Elevation: Codable, Equatable {
        
        let anchor: Anchor
        var elevation: Int
    }
    
    var left = Elevation(anchor: .left, elevation: 0)
    var right = Elevation(anchor: .right, elevation: 0)
    var centre = Elevation(anchor: .centre, elevation: 0)
    
    init(left: Int = 0, right: Int = 0, center: Int = 0) {
        
        self.left.elevation = left
        self.right.elevation = right
        self.centre.elevation = center
    }
}

extension LayerCorners {
    
    public static func == (lhs: LayerCorners, rhs: LayerCorners) -> Bool {
        
        return lhs.left == rhs.left && lhs.right == rhs.right && lhs.centre == rhs.centre
    }
}

extension LayerCorners {
    
    public var base: Int { return min(left.elevation, right.elevation, centre.elevation) }
    public var peak: Int{ return max(left.elevation, right.elevation, centre.elevation) }
}

extension LayerCorners {
    
    func set(elevation: Int) {
        
        left.elevation = elevation
        right.elevation = elevation
        centre.elevation = elevation
    }
}
