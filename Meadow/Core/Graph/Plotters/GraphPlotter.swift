//
//  GraphPlotter.swift
//  Meadow
//
//  Created by Zack Brown on 31/07/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

import Pasture

public protocol GraphPlotter {
    
    var origin: Vector { get }
    
    func plot() -> GraphCache
    
    func quadrangulate(graph: GraphCache) -> GraphCache
}

extension GraphPlotter {
    
    public func quadrangulate(graph: GraphCache) -> GraphCache {
        
        for index in graph.triangles.joints.indices {
            
            let joint = graph.triangles.joints[index]
            
            let edge = graph.triangles.edges[joint.e0]
            
            let v0 = graph.vectors[edge.v0]
            let v1 = graph.vectors[edge.v1]
            let v2 = (v0 + v1) / 2
            
            graph.triangles.joints[index].v = graph.vectors.count
            
            graph.vectors.append(v2)
        }
        
        let indices = graph.triangles.triangles.indices.shuffled()
    
        for index in indices {
            
            guard graph.triangles.find(pair: index) == nil else { continue }
            
            let joins = graph.triangles.find(joints: index).shuffled()
            
            var connected = false
            
            for j in 0..<joins.count {
                
                let joint = joins[j]
                
                let adjacentIndex = (joint.i0 != index ? joint.i0 : joint.i1)
                
                if graph.triangles.find(pair: adjacentIndex) == nil {
                    
                    let pair = graph.triangles.create(pair: joint)
                    
                    graph.divide(pair: pair)
                    
                    connected = true
                    
                    break
                }
            }
            
            if !connected {
            
                graph.divide(triangle: graph.triangles.triangles[index])
            }
        }
        
        return graph
    }
}
