//
//  Stairs.swift
//  
//
//  Created by Zack Brown on 18/05/2021.
//

import SceneKit

public class Stairs: FootprintGrid<StairChunk> {
    
    public override var category: SceneGraphCategory { .stairs }
    
    public lazy var program: SCNProgram? = {
        
        guard let library = scene?.library else { return nil }
        
        return SCNProgram(name: .stairs, library: library)
    }()
    
    public func find(stairs coordinate: Coordinate) -> StairChunk? {
        
        return chunks.first { $0.footprint.intersects(coordinate: coordinate) }
    }
}
