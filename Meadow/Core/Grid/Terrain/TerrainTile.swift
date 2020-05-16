//
//  TerrainTile.swift
//  Meadow
//
//  Created by Zack Brown on 07/02/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

import Pasture

public class TerrainTile<E: TerrainEdge>: Tile, Layerable {
    
    enum CodingKeys: CodingKey {
        
        case edges
    }
    
    var edges: [Cardinal : E] = [:]
    
    public override func encode(to encoder: Encoder) throws {
        
        try super.encode(to: encoder)
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(edges, forKey: .edges)
    }
    
    override func render(transform: Transform) -> Mesh {
        
        var meshes: [Mesh] = []
        
        for (_, edge) in edges where !edge.isHidden {
            
            var mesh = edge.render(transform: transform)
            
            if let edgeMesh = find(neighbour: edge.cardinal)?.find(edge: edge.cardinal.opposite)?.mesh {
                
                mesh = Mesh(polygons: edgeMesh.clip(polygons: mesh.polygons, rule: .greaterThan))
            }
            
            meshes.append(mesh)
        }
        
        var result: [Mesh] = []
        
        for i in meshes.indices {
            
            var m0 = meshes[i]
            
            for j in meshes.indices {
                
                if i != j {
                    
                    let m1 = meshes[j]
                    
                    m0 = Mesh(polygons: m1.clip(polygons: m0.polygons, rule: .greaterThan))
                }
            }
            
            result.append(m0)
        }
        
        return result.union()
    }
    
    public override var children: [SceneGraphNode] { return Array(edges.values) }
    
    public override var category: SceneGraphNodeCategory { return .terrain }
}

extension TerrainTile {
    
    @discardableResult
    func add(edge cardinal: Cardinal, configurator: TerrainEdge.LayerConfigurator) -> E {
        
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
