//
//  Area.swift
//  Meadow
//
//  Created by Zack Brown on 07/02/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

public class Area: LayeredGrid<AreaChunk, AreaTile, AreaEdge, AreaLayer> {
    
    override init(graph: Graph, ancestor: SoilableParent) {
    
        super.init(graph: graph, ancestor: ancestor)
        
        name = "Area"
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    public override var category: SceneGraphNodeCategory { return .area }
}

extension Area: GridDecodable {
    
    typealias JSON = AreaJSON
    
    func decode(json: AreaJSON) {
        
        json.chunks.forEach { chunkJSON in
            
            chunkJSON.tiles.forEach { tileJSON in
                
                tileJSON.edges.forEach { edgeJSON in
                    
                    edgeJSON.layers.forEach { layerJSON in
                            
                        if let layer = self.add(layer: tileJSON.identifier, edgeIdentifier: edgeJSON.identifier) {
                                
                            layer.corners = layerJSON.corners
                        }
                    }
                }
            }
        }
    }
}
