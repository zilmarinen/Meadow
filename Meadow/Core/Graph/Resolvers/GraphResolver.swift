//
//  GraphResolver.swift
//  Meadow
//
//  Created by Zack Brown on 31/07/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

import Pasture

public protocol GraphResolver {
    
    func resolve(graph: GraphCache) -> GraphCache
}

extension GraphResolver {
    
    public func resolve(graph: GraphCache) -> GraphCache {
        
        return relax(graph: graph, iterations: 3)
    }
    
    func relax(graph: GraphCache, iterations: Int) -> GraphCache {
        
        for _ in 0..<iterations {
            
            let indices = graph.quads.quads.indices.shuffled()
            
            for index in indices {
                
                let quad = graph.quads.quads[index]
                
                let e0 = graph.quads.edges[quad.e0]
                let e1 = graph.quads.edges[quad.e1]
                let e2 = graph.quads.edges[quad.e2]
                let e3 = graph.quads.edges[quad.e3]
                
                var maximum = 0.0
                var edges: [Graph.Edge : Double] = [:]
                
                for edge in [e0, e1, e2, e3] {

                    edges[edge] = (1.0 + (quad.v - graph.vectors[edge.v0]).squaredMagnitude)
                    
                    maximum = max(maximum, edges[edge]!)
                }
                
                let interpolator = (1 / maximum)
                
                for (edge, magnitude) in edges {
                    
                    graph.vectors[edge.v0] = quad.v.lerp(vector: graph.vectors[edge.v0], interpolater: interpolator * magnitude)
                }
            }
            
            for index in graph.vectors.indices {

                let joins: [Int] = graph.quads.joints.compactMap {

                    let e0 = graph.quads.edges[$0.e0]

                    return (e0.v0 == index ? e0.v1 : (e0.v1 == index ? e0.v0 : nil))
                }

                guard joins.count > 3 else { continue }

                var v0 = Vector.zero

                for i in joins {

                    v0 = v0 + graph.vectors[i]
                }

                graph.vectors[index] = (v0 / Double(joins.count))
            }
        }
        
        return graph
    }
}
