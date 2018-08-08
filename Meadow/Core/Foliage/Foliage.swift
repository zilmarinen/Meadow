//
//  Foliage.swift
//  Meadow
//
//  Created by Zack Brown on 01/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Foundation

public class Foliage: Grid<FoliageChunk, FoliageTile, FoliageNode>, GridIntermediateLoader {
    
    public typealias IntermediateType = FoliageNodeIntermediate
}

extension Foliage {
    
    public func load(nodes: [FoliageNodeIntermediate]) {
        
        //
    }
}

extension Foliage {
    
    public func add(node coordinate: Coordinate) -> FoliageNode? {
        
        return add(node: FoliageTile.fixedVolume(coordinate))
    }
}
