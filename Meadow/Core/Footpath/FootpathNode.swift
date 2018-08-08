//
//  FootpathNode.swift
//  Meadow
//
//  Created by Zack Brown on 27/04/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

public class FootpathNode: GridNode {
    
    public var slope: Slope? {
        
        didSet {
            
            if slope != oldValue {
                
                becomeDirty()
            }
        }
    }
    
    public var footpathType: FootpathType? {
        
        didSet {
            
            if footpathType != oldValue {
                
                becomeDirty()
            }
        }
    }
    
    enum CodingKeys: CodingKey {
        
        case slope
        case footpathType
    }
    
    public override func encode(to encoder: Encoder) throws {
        
        try super.encode(to: encoder)
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encodeIfPresent(self.slope, forKey: .slope)
        try container.encode(self.footpathType, forKey: .footpathType)
    }
}

extension FootpathNode: GridPolyhedronProvider {
    
    var upperPolytope: Polytope {
        
        let y = (volume.coordinate.y + volume.size.height)
        
        return Polytope(x: MDWFloat(volume.coordinate.x), corners: [y, y, y, y], z: MDWFloat(volume.coordinate.z))!
    }
    
    var lowerPolytope: Polytope {
        
        let y = volume.coordinate.y
        
        return Polytope(x: MDWFloat(volume.coordinate.x), corners: [y, y, y, y], z: MDWFloat(volume.coordinate.z))!
    }
    
    public var polyhedron: Polyhedron { return Polyhedron(upperPolytope: upperPolytope, lowerPolytope: lowerPolytope) }
}

extension FootpathNode {
    
    static var footpathHeight: Int = 6
    
    static func fixedVolume(_ coordinate: Coordinate) -> Volume {
        
        let size = Size(width: World.tileSize, height: footpathHeight, depth: World.tileSize)
        
        return Volume(coordinate: coordinate, size: size)
    }
}
