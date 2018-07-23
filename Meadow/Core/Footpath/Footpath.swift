//
//  Footpath.swift
//  Meadow
//
//  Created by Zack Brown on 27/04/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Foundation

public class Footpath: Grid<FootpathChunk, FootpathTile, FootpathNode>, GridNodeTypeProvider {
    
    public typealias NodeType = FootpathType
    
    public var nodeTypes: [FootpathType] = []
    
    public required override init() {
        
        super.init()
        
        guard let nodeTypes = NodeType.load(filename: "footpath_types") else { fatalError() }
        
        self.nodeTypes = nodeTypes
    }
    
    public required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
}

extension Footpath {
    
    func add(node coordinate: Coordinate) -> FootpathNode? {
        
        return add(node: FootpathTile.fixedVolume(coordinate))
    }
}
