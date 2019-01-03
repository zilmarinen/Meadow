//
//  Footprint.swift
//  Meadow
//
//  Created by Zack Brown on 14/11/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

public struct Footprint: Codable, Hashable {
    
    public let coordinate: Coordinate
    
    public let rotation: GridEdge
    
    //public let nodes: Set<FootprintNode>
    
    public init(coordinate: Coordinate, rotation: GridEdge) {
        
        self.coordinate = coordinate
        self.rotation = rotation
    }
}
