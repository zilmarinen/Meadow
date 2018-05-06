//
//  Terrain.swift
//  Meadow
//
//  Created by Zack Brown on 27/04/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

public class Terrain: Grid<TerrainChunk, TerrainTile, TerrainNode> {

}

extension Terrain {
    
    public func add(node coordinate: Coordinate) -> TerrainNode? {
        
        let volume = TerrainTile.FixedVolume(coordinate)
        
        if let node = add(node: volume) {
            
            GridEdge.Edges.forEach({ edge in
                
                if let neighbour = find(node: volume.coordinate + GridEdge.Cardinal(edge: edge)) {
                    
                    node.add(neighbour: neighbour, edge: edge)
                }
            })
            
            return node
        }
        
        return nil
    }
    
    func remove(node: TerrainNode) {
        
        remove(node: node.volume.coordinate)
        
        GridEdge.Edges.forEach({ edge in
            
            node.remove(neighbour: edge)
        })
    }
}
