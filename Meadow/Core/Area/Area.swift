//
//  Area.swift
//  Meadow
//
//  Created by Zack Brown on 01/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Foundation

public class Area: Grid<AreaChunk, AreaTile, AreaNode>, GridNodeTypeProvider {
    
    public typealias NodeType = AreaType
    
    public var nodeTypes: [AreaType] = []
    
    public required override init() {
        
        super.init()
        
        guard let nodeTypes = NodeType.load(filename: "area_types") else { fatalError() }
        
        self.nodeTypes = nodeTypes
    }
    
    public required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
}

extension Area {
    
    func add(node coordinate: Coordinate) -> AreaNode? {
        
        return add(node: AreaNode.fixedVolume(coordinate))
    }
}
