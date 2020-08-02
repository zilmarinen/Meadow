//
//  HexGraph.swift
//  Meadow
//
//  Created by Zack Brown on 31/07/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

import Pasture

public class HexGraph: GraphPlotter, GraphResolver {
    
    enum Constants {
        
        static let slices = 6
    }
    
    public let rings: Int
    public let size: Double
    
    public var origin = Vector(x: 0.0, y: World.Axis.y(value: World.Constants.floor), z: 0)
    
    public required init(rings: Int = 1, size: Double = 1.0) {
        
        self.rings = max(min(rings, 20), 1)
        self.size = size
    }
    
    public func plot() -> GraphCache {
        
        let cache = GraphCache()
        
        cache.vectors.append(origin)
        
        var offset = 0
        var inner = Array(repeating: [0], count: Constants.slices)
        
        for ring in 0..<rings {
            
            //
            //  Create corners for current hexagon ring
            //
            
            let radius = Double(ring + 1) * size
            
            var corners: [Vector] = []
            
            for index in 0..<Constants.slices {
            
                corners.append(Math.plot(delta: Double(index), slices: Constants.slices) * radius)
            }
            
            //
            //  Calculate outer hexagon vertex indices
            //
            
            let i = (ring * Constants.slices)
            let j = ((ring + 1) * Constants.slices)
            
            let outer = Array(((offset + i) + 1)...((offset + i) + j)).wind(steps: (ring + 2), slices: Constants.slices)
            
            offset += (ring * Constants.slices)
            
            //
            //  Create vertices along edge of slice
            //
            
            for index in 0..<Constants.slices {
                
                let v0 = corners[index]
                let v1 = corners[((index + 1) % Constants.slices)]
                
                cache.vectors.append(origin + v0)
                
                if ring > 0 {
                
                    let step = 1.0 / Double(ring + 1)
                    
                    for division in 1..<(ring + 1) {
                        
                        cache.vectors.append(origin + v0.lerp(vector: v1, interpolater: step * Double(division)))
                    }
                }
                
                //
                //  Calculate inner hexagon vertex indices
                //
                
                let inside = inner[index]
                let outside = outer[index]
                
                let lhs: [[Int]] = (ring == 0 ? [] : (ring == 1 ? [inside] : inside.wind(steps: 2, slices: ring)))
                let rhs: [Int] = (ring == 0 ? [] : (ring == 1 ? [outside[1]] : Array(outside[1..<(outside.count - 1)])))
                let adjacent = outside.wind(steps: 2, slices: ring + 1)
                
                for k in 0..<lhs.count {
                    
                    cache.triangles.create(triangle: lhs[k][0], v1: lhs[k][1], v2: rhs[k])
                }

                for k in 0..<inside.count {
                    
                    cache.triangles.create(triangle: adjacent[k][0], v1: inside[k], v2: adjacent[k][1])
                }
            }
            
            inner = outer
        }
        
        return cache
    }
}

