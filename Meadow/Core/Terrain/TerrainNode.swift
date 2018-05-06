//
//  TerrainNode.swift
//  Meadow
//
//  Created by Zack Brown on 27/04/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

public class TerrainNode: GridNode {
    
    private var neighbours: Set<GridNodeNeighbour> = []
    
    private var layers: Set<TerrainLayer> = []
}

extension TerrainNode {
    
    func add(neighbour node: TerrainNode, edge: GridEdge) {
        
        if node.volume.coordinate.adjacency(to: volume.coordinate) != .adjacent {
            
            return
        }
     
        remove(neighbour: edge)
        
        neighbours.insert(GridNodeNeighbour(edge: edge, node: node))
        
        let oppositeEdge = GridEdge.Opposite(edge: edge)
        
        if node.find(neighbour: oppositeEdge) == nil {
            
            node.add(neighbour: self, edge: oppositeEdge)
        }
        
        becomeDirty()
    }
    
    func remove(neighbour edge: GridEdge) {
        
        if let neighbour = find(neighbour: edge) {
            
            neighbours.remove(neighbour)
            
            guard let neighbouringNode = neighbour.node as? TerrainNode else { return }
            
            let oppositeEdge = GridEdge.Opposite(edge: edge)
            
            if let _ = neighbouringNode.find(neighbour: oppositeEdge) {
                
                neighbouringNode.remove(neighbour: oppositeEdge)
            }
            
            becomeDirty()
        }
    }
    
    func find(neighbour edge: GridEdge) -> GridNodeNeighbour? {
        
        return neighbours.first { neighbour -> Bool in
            
            return neighbour.edge == edge
        }
    }
}

extension TerrainNode {
    
    func add(layer: TerrainLayer) {
        
        //
    }
    
    func remove(layer: TerrainLayer) {
        
        //
    }
}
