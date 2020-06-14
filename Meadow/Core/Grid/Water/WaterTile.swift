//
//  WaterTile.swift
//  Meadow
//
//  Created by Zack Brown on 07/02/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

import Pasture

public class WaterTile<E: WaterEdge>: Tile, Layerable {
    
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
        
        var mesh = Mesh(polygons: [])
        
        for (_, edge) in edges where !edge.isHidden {
            
            mesh = mesh.union(mesh: edge.render(transform: transform))
        }
        
        return mesh
    }
    
    public override var children: [SceneGraphNode] { return Array(edges.values) }
    
    public override var category: SceneGraphNodeCategory { return .water }
}

extension WaterTile {
    
    public func add(edge cardinal: Cardinal) -> E {
        
        let edge = find(edge: cardinal) ?? E(ancestor: self, coordinate: volume.coordinate, cardinal: cardinal)
        
        if edge.layers.isEmpty {
            
            let _ = edge.addLayer()
        }
        
        self.edges.updateValue(edge, forKey: cardinal)
        
        return edge
    }
}
