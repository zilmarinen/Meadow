//
//  TerrainTile.swift
//  Meadow
//
//  Created by Zack Brown on 07/02/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

import Pasture

public class TerrainTile<E: TerrainEdge>: Tile, Layerable {
    
    var edges: [Cardinal : E] = [:]
    
    override func render(transform: Transform) -> Mesh {
        
        var meshes: [Mesh] = []
        
        for (_, edge) in edges {
            
            let mesh = edge.render(transform: transform)
            
            meshes.append(mesh)
        }
        
        return meshes.union()
    }
}

extension TerrainTile {
    
    @discardableResult
    func add(edge cardinal: Cardinal, configurator: Layer.Configurator) -> E {
        
        let edge = find(edge: cardinal) ?? E(ancestor: self, cardinal: cardinal)
        
        if edge.layers.isEmpty {
            
            edge.add { layer in
                
                let (o0, o1) = layer.cardinal.ordinals
                
                let elevation = (layer.lower?.peak ?? World.Constants.floor) + 1
                
                layer.set(center: elevation)
                layer.set(ordinal: o0, elevation: elevation)
                layer.set(ordinal: o1, elevation: elevation)
                
                configurator(layer)
            }
        }
        
        self.edges.updateValue(edge, forKey: cardinal)
        
        return edge
    }
}
