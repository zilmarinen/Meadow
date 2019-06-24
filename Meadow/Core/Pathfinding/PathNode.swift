//
//  PathNode.swift
//  Meadow
//
//  Created by Zack Brown on 19/06/2019.
//  Copyright © 2019 Script Orchard. All rights reserved.
//

import Foundation
import SceneKit

public struct PathNode: PriorityQueueNode {
    
    public typealias PathLocus = (coordinate: Coordinate, edge: GridEdge)
    
    public let locus: PathLocus
    
    public let movementCost: Int
    
    public let neighbours: [PathLocus]?
    
    public var priority: Int
    
    init(locus: PathLocus, movementCost: Int, neighbours: [PathLocus]?) {
        
        self.locus = locus
        self.movementCost = movementCost
        self.neighbours = neighbours
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

/*

frontier = PriorityQueue()
frontier.put(start, 0)
came_from = {}
cost_so_far = {}
came_from[start] = None
cost_so_far[start] = 0

while not frontier.empty():

    current = frontier.get()

    if current == goal:

        break

    for next in graph.neighbors(current):

        new_cost = cost_so_far[current] + graph.cost(current, next)

        if next not in cost_so_far or new_cost < cost_so_far[next]:

            cost_so_far[next] = new_cost

            priority = new_cost + heuristic(goal, next)

            frontier.put(next, priority)

            came_from[next] = current
 
 //
 
 def reconstruct_path(came_from, start, goal):
 
    current = goal
 
    path = []
 
    while current != start:
 
        path.append(current)
 
        current = came_from[current]
 
    path.append(start) # optional
 
    path.reverse() # optional
 
    return path
*/
