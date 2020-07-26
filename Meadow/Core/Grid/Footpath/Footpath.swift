//
//  Footpath.swift
//  Meadow
//
//  Created by Zack Brown on 07/02/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

public class Footpath: LayeredGrid<FootpathChunk, FootpathTile, FootpathEdge, FootpathLayer> {
    
    override init(graph: Graph, ancestor: SoilableParent) {
    
        super.init(graph: graph, ancestor: ancestor)
        
        name = "Footpath"
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    public override var category: SceneGraphNodeCategory { return .footpath }
}

extension Footpath: GridDecodable {
    
    typealias JSON = FootpathJSON
    
    func decode(json: FootpathJSON) {
        
        json.chunks.forEach { chunkJSON in
            
            chunkJSON.tiles.forEach { tileJSON in
                
                if let tile = self.add(tile: tileJSON.identifier) {

                    tileJSON.edges.forEach { edgeJSON in
                        
                        let edge = tile.add(edge: edgeJSON.identifier)

                        edgeJSON.layers.forEach { layerJSON in

                            if let layer = edge.addLayer() {

                                layer.footpathType = layerJSON.footpathType
                                layer.corners = layerJSON.corners
                            }
                        }
                    }
                }
            }
        }
    }
}
