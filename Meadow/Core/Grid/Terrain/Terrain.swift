//
//  Terrain.swift
//  Meadow
//
//  Created by Zack Brown on 07/02/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

public class Terrain: Grid<TerrainChunk, TerrainTile<TerrainEdge>> {
    
    override init() {
        
        super.init()
        
        name = "Terrain"
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
}

public extension Terrain {
    
    @discardableResult
    func add(tile coordinate: Coordinate, configurator: Layer.Configurator) -> TerrainTile<TerrainEdge> {
        
        let tile = find(tile: coordinate) ?? add(tile: coordinate)
        
        for cardinal in Cardinal.allCases {
            
            if tile.find(edge: cardinal) == nil {
                
                tile.add(edge: cardinal, configurator: configurator)
            }
        }
        
        return tile
    }
    
    @discardableResult
    func add(layer coordinate: Coordinate, cardinal: Cardinal, configurator: Layer.Configurator) -> TerrainLayer? {
        
        let tile = find(tile: coordinate) ?? add(tile: coordinate)
        
        if let edge = tile.find(edge: cardinal) {
            
            return edge.add(layer: configurator)
        }
        
        let edge = tile.add(edge: cardinal, configurator: configurator)
        
        return edge.topLayer
    }
}
