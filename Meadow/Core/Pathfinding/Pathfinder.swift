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
        
        guard let startNode = node(at: origin), let endNode = node(at: destination) else { return nil }
        
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
            
            guard let pathNodeCost = cost[pathNode] else { continue }
            
            pathNode.neighbours?.forEach { neighbour in
                
                if var neighbourNode = node(at: neighbour) {
                
                    let neighbourNodeCost = pathNodeCost + neighbourNode.movementCost
                    
                    if cost[neighbourNode] == nil || (neighbourNodeCost < (cost[neighbourNode] ?? 0)) {
                        
                        cost[neighbourNode] = neighbourNodeCost
                        
                        neighbourNode.priority = neighbourNodeCost + heuristic(between: neighbourNode.locus.coordinate, destination: destination.coordinate)
                        
                        queue.push(node: neighbourNode)
                        
                        closed[neighbourNode] = pathNode
                    }
                }
            }
        }
     
        return nil
    }
    
    func heuristic(between origin: Coordinate, destination: Coordinate) -> Int {
        
        return abs(origin.x - destination.x) + abs(origin.y - destination.y) + abs(origin.z - destination.z)
    }
}

extension Pathfinder {
    
    func node(at locus: PathNode.PathLocus) -> PathNode? {
        
        guard let gridNode = areas.find(node: locus.coordinate) ?? footpaths.find(node: locus.coordinate) ?? terrain.find(node: locus.coordinate) else { return nil }
        
        let oppositeEdge = GridEdge.opposite(edge: locus.edge)
        
        let adjacentEdges = GridEdge.Edges.compactMap { $0 != locus.edge ? $0 : nil }
        
        var movementCost = 0
        
        var neighbours: [PathNode.PathLocus] = []
        
        if let areaNode = gridNode as? AreaNode {
            
            movementCost = areaNode.floor?.floorType.movementCost ?? movementCost
            
            adjacentEdges.forEach { edge in
                
                neighbours.append(PathNode.PathLocus(coordinate: locus.coordinate, edge: edge))
            }
            
            if let areaNodeEdge = areaNode.find(edge: locus.edge) {
                
                switch areaNodeEdge.edgeType {
                    
                case .door:
                    
                    neighbours.append(PathNode.PathLocus(coordinate: locus.coordinate + GridEdge.extent(edge: locus.edge), edge: oppositeEdge))
                
                default: break
                }
            }
        }
        else if let footpathNode = gridNode as? FootpathNode {
            
            movementCost = footpathNode.footpathType?.movementCost ?? movementCost
            
            adjacentEdges.forEach { edge in
                
                neighbours.append(PathNode.PathLocus(coordinate: locus.coordinate, edge: edge))
            }
            
            if let footpathNeighbourNode = footpathNode.find(neighbour: locus.edge)?.node {
                
                neighbours.append(PathNode.PathLocus(coordinate: footpathNeighbourNode.volume.coordinate, edge: oppositeEdge))
            }
        }
        else if let terrainNode = gridNode as? TerrainNode, let terrainNodeEdge = terrainNode.find(edge: locus.edge) {
            
            movementCost = terrainNodeEdge.topLayer?.terrainType.movementCost ?? movementCost
            
            adjacentEdges.forEach { edge in
                
                neighbours.append(PathNode.PathLocus(coordinate: locus.coordinate, edge: edge))
            }
            
            if let terrainNeighbourNode = terrainNode.find(neighbour: locus.edge)?.node as? TerrainNode, let terrainNodeEdge = terrainNeighbourNode.find(edge: oppositeEdge) {
                
                //
            }
        }
        
        return PathNode(locus: locus, movementCost: movementCost, neighbours: neighbours)
    }
    
    func node(isWalkable node: PathNode) -> Bool {
        
        return props.find(prop: node.locus.coordinate, edge: node.locus.edge) == nil
    }
}
