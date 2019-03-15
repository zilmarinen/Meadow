//
//  FootpathResolver.swift
//  Meadow-iOS
//
//  Created by Zack Brown on 13/03/2019.
//  Copyright © 2019 Script Orchard. All rights reserved.
//

class FootpathResolver: GridResolver {
    
    var volumes: Set<Volume> = []
    
    let footpaths: Footpath
    
    let terrain: Terrain
    
    init(footpaths: Footpath, terrain: Terrain) {
        
        self.footpaths = footpaths
        
        self.terrain = terrain
    }
}

extension FootpathResolver {
    
    func clean(volume: Volume) {
        
        guard let footpathTile = footpaths.find(tile: volume.coordinate) else { return }
        
        guard terrain.find(node: volume.coordinate) != nil, footpathTile.totalChildren > 0 else {
            
            footpaths.remove(tile: footpathTile)
            
            return
        }
        
        GridEdge.Edges.forEach { edge in
            
            let footpathTileNeighbour = footpaths.find(tile: volume.coordinate + GridEdge.extent(edge: edge))
            
            footpathTile.children.forEach { footpathNode in
            
                var neighbour: FootpathNode? = nil
                
                if let footpathTileNeighbour = footpathTileNeighbour {
                    
                    for index in 0..<footpathTileNeighbour.totalChildren {
                    
                        if let footpathNodeNeighbour = footpathTileNeighbour.child(at: index) as? FootpathNode {
                            
                            let corners = GridCorner.corners(edge: edge)
                            let c0adjacent = GridCorner.adjacent(corner: corners.c0, edge: edge)
                            let c1adjacent = GridCorner.adjacent(corner: corners.c1, edge: edge)
                            
                            let c0 = footpathNode.corners[corners.c0.rawValue]
                            let c1 = footpathNode.corners[corners.c1.rawValue]
                            let c2 = footpathNodeNeighbour.corners[c0adjacent.rawValue]
                            let c3 = footpathNodeNeighbour.corners[c1adjacent.rawValue]
                            
                            if (c0 == c2 && c1 == c3) {
                                
                                neighbour = footpathNodeNeighbour
                                
                                break
                            }
                        }
                    }
                }
                
                if let neighbour = neighbour {
                    
                    footpathNode.add(neighbour: neighbour, edge: edge)
                }
                else {
                    
                    footpathNode.remove(neighbour: edge)
                }
            }
        }
    }
}
