//
//  Water.swift
//  Meadow
//
//  Created by Zack Brown on 01/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Foundation

public class Water: Grid<WaterChunk, WaterTile, WaterNode>, GridNodeTypeProvider {
    
    public typealias NodeType = WaterType
    
    public var nodeTypes: [WaterType] = []
    
    public required override init() {
        
        super.init()
        
        guard let nodeTypes = NodeType.load(filename: "water_types") else { fatalError() }
        
        self.nodeTypes = nodeTypes
    }
    
    public required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
}

extension Water {
    
    func add(node coordinate: Coordinate) -> WaterNode? {
        
        return add(node: WaterTile.fixedVolume(coordinate))
    }
}
