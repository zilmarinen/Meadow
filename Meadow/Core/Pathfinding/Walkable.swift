//
//  Walkable.swift
//  Meadow
//
//  Created by Zack Brown on 28/06/2019.
//  Copyright © 2019 Script Orchard. All rights reserved.
//

public protocol Walkable {
    
    func pathNode(for edge: GridEdge) -> PathNode?
    func neighbours(for edge: GridEdge) -> [PathNode]?
}
