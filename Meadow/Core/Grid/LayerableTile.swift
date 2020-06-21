//
//  LayerableTile.swift
//  Meadow-iOS
//
//  Created by Zack Brown on 18/06/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

import Pasture

public class LayerableTile<E: Edge<L>, L: Layer>: Tile {
    
    enum CodingKeys: CodingKey {
        
        case edges
    }
    
    public var edges: [Cardinal : E] = [:]
    
    public override func encode(to encoder: Encoder) throws {
        
        try super.encode(to: encoder)
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(edges, forKey: .edges)
    }
    
    public override func clean() -> Bool {
        
        guard isDirty else { return false }
        
        edges.forEach { (_, edge) in
            
            edge.clean()
        }
        
        return super.clean()
    }
    
    override func render(transform: Transform) -> Mesh {
        
        guard isDirty else { return self.mesh }
        
        var polygons: [Pasture.Polygon] = []
        
        for (_, edge) in edges where !edge.isHidden {
            
            polygons.append(contentsOf: edge.render(transform: transform).polygons)
        }
        
        return Mesh(polygons: polygons)
    }
    
    public override var children: [SceneGraphNode] { return Array(edges.values) }
}

extension LayerableTile {
    
    public func add(edge cardinal: Cardinal) -> E {
        
        let edge = find(edge: cardinal) ?? E(ancestor: self, coordinate: volume.coordinate, cardinal: cardinal)
        
        if edge.layers.isEmpty {
            
            let _ = edge.addLayer()
        }
        
        self.edges.updateValue(edge, forKey: cardinal)
        
        return edge
    }
    
    public func find(edge cardinal: Cardinal) -> E? {
        
        return edges[cardinal]
    }
    
    public func remove(edge cardinal: Cardinal) {
        
        if find(edge: cardinal) != nil {
            
            edges.removeValue(forKey: cardinal)
            
            becomeDirty()
            
            if let neighbour = find(neighbour: cardinal), let connectedEdge = neighbour.find(edge: cardinal.opposite) {
                
                connectedEdge.becomeDirty()
            }
        }
    }
}

