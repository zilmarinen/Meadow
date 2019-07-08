//
//  Pathfinder.swift
//  Meadow
//
//  Created by Zack Brown on 21/06/2019.
//  Copyright © 2019 Script Orchard. All rights reserved.
//

import Foundation

public class Pathfinder {
    
    let areas: Area
    let footpaths: Footpath
    let props: Props
    let terrain: Terrain
    
    init(areas: Area, footpaths: Footpath, props: Props, terrain: Terrain) {
        
        self.areas = areas
        self.footpaths = footpaths
        self.props = props
        self.terrain = terrain
    }
}

extension Pathfinder {
    
    public func path(between origin: PathNode.PathLocus, destination: PathNode.PathLocus) -> Path? {
        
        guard let startNode = pathNode(at: origin), let endNode = pathNode(at: destination) else { return nil }
        
        let queue = PriorityQueue<PathNode>()
        
        var closed: [PathNode: PathNode?] = [startNode : nil]
        
        var cost: [PathNode: Int] = [startNode : 0]
        
        queue.push(node: startNode)
        
        while !queue.isEmpty {
            
            let pathNode = queue.pop()
            
            if pathNode.locus.coordinate == endNode.locus.coordinate && pathNode.locus.edge == endNode.locus.edge {
                
                var pathNodes: [PathNode] = []
                
                var nextPathNode: PathNode? = endNode
                
                while nextPathNode != startNode {
                    
                    guard let visited = nextPathNode else { break }
                    
                    pathNodes.append(visited)
                    
                    nextPathNode = closed[visited] ?? nil
                }
                
                pathNodes.append(startNode)
                
                return Path(nodes: pathNodes.reversed())
            }
            
            guard let pathNodeCost = cost[pathNode], let neighbours = neighbours(at: pathNode.locus) else { continue }
            
            neighbours.forEach { neighbour in
                
                let neighbourNodeCost = pathNodeCost + neighbour.movementCost
                
                if !closed.keys.contains(neighbour) && (cost[neighbour] == nil || (neighbourNodeCost < (cost[neighbour] ?? 0))) {
                    
                    cost[neighbour] = neighbourNodeCost
                    
                    neighbour.priority = neighbourNodeCost + heuristic(between: neighbour.locus.coordinate, destination: destination.coordinate)
                    
                    queue.push(node: neighbour)
                    
                    closed[neighbour] = pathNode
                }
            }
        }
     
        return nil
    }
}

extension Pathfinder {
    
    func gridNode(at locus: PathNode.PathLocus) -> GridNode? {
        
        guard self.pathNode(isWalkable: locus) else { return nil }
        
        return areas.find(node: locus.coordinate) ?? footpaths.find(node: locus.coordinate) ?? terrain.find(node: locus.coordinate)
    }
    
    func pathNode(at locus: PathNode.PathLocus) -> PathNode? {
        
        guard let node = gridNode(at: locus) as? Walkable else { return nil }
        
        return node.pathNode(for: locus.edge)
    }
    
    func neighbours(at locus: PathNode.PathLocus) -> [PathNode]? {
        
        guard let node = gridNode(at: locus) as? Walkable else { return nil }
        
        return node.neighbours(for: locus.edge)?.compactMap { pathNode(at: $0.locus) }
    }
    
    func pathNode(isWalkable locus: PathNode.PathLocus) -> Bool {
        
        return props.find(prop: locus.coordinate, edge: locus.edge) == nil
    }
    
    func heuristic(between origin: Coordinate, destination: Coordinate) -> Int {
        
        return abs(origin.x - destination.x) + abs(origin.y - destination.y) + abs(origin.z - destination.z)
    }
}
