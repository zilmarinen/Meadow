//
//  Terrain.swift
//  Meadow
//
//  Created by Zack Brown on 07/02/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

public class Terrain: Grid<TerrainChunk, TerrainTile<TerrainEdge>> {
    
    override init(ancestor: SoilableParent) {
    
    super.init(ancestor: ancestor)
        
        name = "Terrain"
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    public override var category: SceneGraphNodeCategory { return .terrain }
}

extension Terrain: GridDecodable {
    
    typealias JSON = TerrainJSON
    
    func decode(json: TerrainJSON) {
        
        json.chunks.forEach { chunkJSON in
            
            chunkJSON.tiles.forEach { tileJSON in
                
                tileJSON.edges.forEach { edgeJSON in
                    
                    edgeJSON.layers.forEach { layerJSON in
                        
                        self.add(layer: tileJSON.coordinate, cardinal: edgeJSON.cardinal) { layer in
                            
                            layer.color = .black
                        }
                    }
                }
            }
        }
    }
}

public extension Terrain {
    
    @discardableResult
    func add(tile coordinate: Coordinate, configurator: TerrainEdge.LayerConfigurator) -> TerrainTile<TerrainEdge> {
        
        let tile = find(tile: coordinate) ?? add(tile: coordinate)
        
        for cardinal in Cardinal.allCases {
            
            if tile.find(edge: cardinal) == nil {
                
                tile.add(edge: cardinal, configurator: configurator)
            }
        }
        
        return tile
    }
    
    @discardableResult
    func add(layer coordinate: Coordinate, cardinal: Cardinal, configurator: TerrainEdge.LayerConfigurator) -> TerrainLayer? {
        
        let tile = find(tile: coordinate) ?? add(tile: coordinate)
        
        if let edge = tile.find(edge: cardinal) {
            
            return edge.add(layer: configurator)
        }
        
        let edge = tile.add(edge: cardinal, configurator: configurator)
        
        return edge.topLayer
    }
}
