//
//  FootprintNode.swift
//  Meadow
//
//  Created by Zack Brown on 14/11/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

public struct FootprintNode: Codable, Hashable {
    
    public let coordinate: Coordinate
    
    public let edges: Set<GridEdge>
}
