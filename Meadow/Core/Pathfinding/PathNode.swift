//
//  PathNode.swift
//  Meadow
//
//  Created by Zack Brown on 19/06/2019.
//  Copyright © 2019 Script Orchard. All rights reserved.
//

import Foundation
import SceneKit

public class PathNode: PriorityQueueNode {
    
    public typealias PathLocus = (coordinate: Coordinate, edge: GridEdge)
    
    public let locus: PathLocus
    
    public let position: SCNVector3
    
    public let movementCost: Int
    
    public var priority: Int
    
    init(locus: PathLocus, position: SCNVector3, movementCost: Int) {
        
        self.locus = locus
        self.position = position
        self.movementCost = movementCost
        self.priority = 0
    }
}

extension PathNode: Equatable {
    
    public static func == (lhs: PathNode, rhs: PathNode) -> Bool {
        
        return lhs.locus.coordinate == rhs.locus.coordinate && lhs.locus.edge == rhs.locus.edge && lhs.movementCost == rhs.movementCost
    }
}

extension PathNode: Hashable {
    
    public func hash(into hasher: inout Hasher) {
        
        hasher.combine(locus.coordinate)
        hasher.combine(locus.edge)
        hasher.combine(movementCost)
    }
}
