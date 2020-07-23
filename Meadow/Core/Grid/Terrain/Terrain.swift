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
        
//        json.chunks.forEach { chunkJSON in
//            
//            chunkJSON.tiles.forEach { tileJSON in
//                
//                tileJSON.edges.forEach { edgeJSON in
//                    
//                    edgeJSON.layers.forEach { layerJSON in
//                        
//                        let layer = self.add(layer: tileJSON.coordinate, cardinal: edgeJSON.cardinal)
//                            
//                        layer?.terrainType = layerJSON.terrainType
//                    }
//                }
//            }
//        }
    }
}
