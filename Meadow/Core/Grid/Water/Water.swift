//
//  Water.swift
//  Meadow
//
//  Created by Zack Brown on 07/02/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

public class Water: LayeredGrid<WaterChunk, WaterTile, WaterEdge, WaterLayer> {
    
    override init(ancestor: SoilableParent) {
    
    super.init(ancestor: ancestor)
        
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
                
                tileJSON.edges.forEach { edgeJSON in
                    
                    edgeJSON.layers.forEach { layerJSON in
                        
                        let layer = self.add(layer: tileJSON.coordinate, cardinal: edgeJSON.cardinal)
                        
                        layer?.waterType = layerJSON.waterType
                    }
                }
            }
        }
    }
}
