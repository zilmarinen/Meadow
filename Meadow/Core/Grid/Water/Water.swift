//
//  Water.swift
//  Meadow
//
//  Created by Zack Brown on 07/02/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

public class Water: LayeredGrid<WaterChunk, WaterTile, WaterEdge, WaterLayer> {
    
    override init(graph: Graph, ancestor: SoilableParent) {
    
        super.init(graph: graph, ancestor: ancestor)
        
        name = "Water"
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    public override var category: SceneGraphNodeCategory { return .water }
}

extension Water: GridDecodable {
    
    typealias JSON = WaterJSON
    
    func decode(json: WaterJSON) {
        
        json.chunks.forEach { chunkJSON in
            
            chunkJSON.tiles.forEach { tileJSON in
                
                if let tile = self.add(tile: tileJSON.identifier) {

                    tileJSON.edges.forEach { edgeJSON in
                        
                        let edge = tile.add(edge: edgeJSON.identifier)

                        edgeJSON.layers.forEach { layerJSON in

                            if let layer = edge.addLayer() {

                                layer.waterType = layerJSON.waterType
                                layer.corners = layerJSON.corners
                            }
                        }
                    }
                }
            }
        }
    }
}
