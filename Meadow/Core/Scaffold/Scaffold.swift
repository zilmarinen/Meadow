//
//  Scaffold.swift
//  Meadow
//
//  Created by Zack Brown on 01/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Foundation

public class Scaffold: Grid<ScaffoldChunk, ScaffoldTile, ScaffoldNode>, GridNodeTypeProvider {
    
    public typealias NodeType = ScaffoldType
    
    public var nodeTypes: [ScaffoldType] = []
    
    public required override init() {
        
        super.init()
        
        guard let nodeTypes = NodeType.load(filename: "scaffold_types") else { fatalError() }
        
        self.nodeTypes = nodeTypes
    }
    
    public required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
}

extension Scaffold {
    
    func add(node coordinate: Coordinate) -> ScaffoldNode? {
        
        return add(node: ScaffoldTile.fixedVolume(coordinate))
    }
}
