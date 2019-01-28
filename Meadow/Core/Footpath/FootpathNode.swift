//
//  FootpathNode.swift
//  Meadow
//
//  Created by Zack Brown on 27/04/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import SceneKit

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
    
    public override var mesh: Mesh {
        
        return Mesh(faces: [])
    }
}

extension FootpathNode: GridPolyhedronProvider {
    
    var upperPolytope: Polytope {
        
        let (c0, c1, c2, c3) = (corners[0], corners[1], corners[2], corners[3])
        
        return Polytope(x: MDWFloat(volume.coordinate.x), y0: c0 + volume.size.height, y1: c1 + volume.size.height, y2: c2 + volume.size.height, y3: c3 + volume.size.height, z: MDWFloat(volume.coordinate.z))
    }
    
    var lowerPolytope: Polytope {
        
        let (c0, c1, c2, c3) = (corners[0], corners[1], corners[2], corners[3])
        
        return Polytope(x: MDWFloat(volume.coordinate.x), y0: c0, y1: c1, y2: c2, y3: c3, z: MDWFloat(volume.coordinate.z))
    }
    
    public var polyhedron: Polyhedron { return Polyhedron(upperPolytope: upperPolytope, lowerPolytope: lowerPolytope) }
}

extension FootpathNode {
    
    var corners: [Int] {
        
        let y = volume.coordinate.y
        
        var heights = [y, y, y, y]
        
        if let slope = slope {
        
            let (c0, c1) = GridCorner.corners(edge: slope.edge)
        
            heights[c0.rawValue] += (slope.steep ? 2 : 1)
            heights[c1.rawValue] += (slope.steep ? 2 : 1)
        }
        
        return heights
    }
}

extension FootpathNode {
    
    static let kerb: MDWFloat = 0.1
    static let surface: MDWFloat = 0.01
    
    static let footpathHeight: Int = 6
    
    static func fixedVolume(_ coordinate: Coordinate) -> Volume {
        
        let size = Size(width: World.tileSize, height: footpathHeight, depth: World.tileSize)
        
        return Volume(coordinate: coordinate, size: size)
    }
}
