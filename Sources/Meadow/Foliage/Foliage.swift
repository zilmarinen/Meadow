//
//  Foliage.swift
//
//  Created by Zack Brown on 27/03/2021.
//

import SceneKit

public class Foliage: FootprintGrid<FoliageChunk> {
    
    public override var category: Int { SceneGraphCategory.foliage.rawValue }
    
    public lazy var program: SCNProgram? = {
        
        guard let library = scene?.library else { return nil }
        
        return SCNProgram(name: .foliage, library: library)
    }()
    
    func find(foliage coordinate: Coordinate) -> FoliageChunk? {
        
        return chunks.first { $0.footprint.intersects(coordinate: coordinate) }
    }
}
