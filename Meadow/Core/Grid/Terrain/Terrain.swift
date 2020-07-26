//
//  Terrain.swift
//  Meadow
//
//  Created by Zack Brown on 07/02/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

public class Terrain: LayeredGrid<TerrainChunk, TerrainTile, TerrainEdge, TerrainLayer> {
    
    override init(graph: Graph, ancestor: SoilableParent) {
    
        super.init(graph: graph, ancestor: ancestor)
        
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
            
            print("chunk [\(chunkJSON.segment)|\(chunkJSON.radius)] has [\(chunkJSON.tiles.count)] tiles")
            
            chunkJSON.tiles.forEach { tileJSON in
                
                print("tile [\(tileJSON.identifier)] has [\(tileJSON.edges.count)] edges")
                
                if let tile = self.add(tile: tileJSON.identifier) {
                 
                    tileJSON.edges.forEach { edgeJSON in
                        
                        print("edge has [\(edgeJSON.layers.count)] layers")
                        
                        let edge = tile.add(edge: edgeJSON.identifier)
                        
                        edgeJSON.layers.forEach { layerJSON in
                                
                            if let layer = edge.addLayer() {
                            
                                layer.terrainType = layerJSON.terrainType
                                layer.corners = layerJSON.corners
                                layer.ancestor = edge
                            }
                        }
                    }
                }
            }
        }
    }
}
