//
//  Terrain.swift
//  Meadow
//
//  Created by Zack Brown on 07/02/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

public class Terrain: Grid<TerrainChunk, TerrainTile> {
    
    override init(ancestor: SoilableParent) {
    
    super.init(ancestor: ancestor)
        
        name = "Terrain"
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    public override var category: SceneGraphNodeCategory { return .terrain }
    
    public override func add(tile coordinate: Coordinate) -> TerrainTile {
        
        let tile = super.add(tile: coordinate)
        
        for cardinal in Cardinal.allCases {
            
            if tile.find(edge: cardinal) == nil {
                
                let _ = tile.add(edge: cardinal)
            }
        }
        
        return tile
    }
}

extension Terrain: GridDecodable {
    
    typealias JSON = TerrainJSON
    
    func decode(json: TerrainJSON) {
        
        json.chunks.forEach { chunkJSON in
            
            chunkJSON.tiles.forEach { tileJSON in
                
                tileJSON.edges.forEach { edgeJSON in
                    
                    edgeJSON.layers.forEach { layerJSON in
                        
                        let layer = self.add(layer: tileJSON.coordinate, cardinal: edgeJSON.cardinal)
                            
                        layer?.terrainType = layerJSON.terrainType
                    }
                }
            }
        }
    }
}

public extension Terrain {
    
    func add(layer coordinate: Coordinate, cardinal: Cardinal) -> TerrainLayer? {
        
        let tile = find(tile: coordinate) ?? super.add(tile: coordinate)
        
        if let edge = tile.find(edge: cardinal) {
            
            return edge.addLayer()
        }
        
        let edge = tile.add(edge: cardinal)
        
        return edge.topLayer
    }
}
