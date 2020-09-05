//
//  LaplacianResolver.swift
//  Meadow
//
//  Created by Zack Brown on 04/08/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

import Pasture

public struct LaplacianResolver: GraphResolver {
    
    let iterations: Int
    
    public init(iterations: Int) {
        
        self.iterations = iterations
    }
}

extension LaplacianResolver {
    
    public func resolve(graph: GraphCache) -> GraphCache {
        
        for _ in 0..<iterations {
        
            for index in graph.vectors.indices {
                
                let joints = graph.quads.find(edges: index).map { graph.quads.find(joint: $0) }.first { $0?.e1 == -1 }
                
                guard joints == nil else { continue }
                
                let vector = graph.vectors[index]
                
                let vectors = graph.quads.find(vectors: index).map { graph.vectors[$0] }
                
                var x = 0.0
                var z = 0.0
                var weight = 0.0
                
                for neighbour in vectors {
                    
                    let w = sqrt(pow(vector.x - neighbour.x, 2) + pow(vector.z - neighbour.z, 2))
                    
                    x += neighbour.x * w
                    z += neighbour.z * w
                
                    weight += w
                    
                }
                
                graph.vectors[index] = Vector(x: x / weight, y: vector.y, z: z / weight)
            }
        }
        
        return graph
    }
}
