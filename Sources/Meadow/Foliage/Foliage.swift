//
//  Foliage.swift
//
//  Created by Zack Brown on 27/03/2021.
//

import SceneKit

class Foliage: FootprintGrid<FoliageChunk> {
    
    lazy var program: SCNProgram? = {
        
        guard let library = scene?.library else { return nil }
        
        return SCNProgram(name: .foliage, library: library)
    }()
    
    func find(foliage coordinate: Coordinate) -> FoliageChunk? {
        
        //TODO: Fix all find -> Chunk methods
        return nil
        //return chunks.first { $0.footprint.intersects(coordinate: coordinate) }
    }
}
