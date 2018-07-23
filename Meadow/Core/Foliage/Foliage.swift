//
//  Foliage.swift
//  Meadow
//
//  Created by Zack Brown on 01/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Foundation

public class Foliage: Grid<FoliageChunk, FoliageTile, FoliageNode>, GridNodeTypeProvider {
    
    public typealias NodeType = FoliageType
    
    public var nodeTypes: [FoliageType] = []
    
    public required override init() {
        
        super.init()
        
        guard let nodeTypes = NodeType.load(filename: "foliage_types") else { fatalError() }
        
        self.nodeTypes = nodeTypes
    }
    
    public required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
}

extension Foliage {
    
    func add(node coordinate: Coordinate) -> FoliageNode? {
        
        return add(node: FoliageTile.fixedVolume(coordinate))
    }
}
