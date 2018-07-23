//
//  Terrain.swift
//  Meadow
//
//  Created by Zack Brown on 27/04/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Foundation

public class Terrain: Grid<TerrainChunk, TerrainTile, TerrainNode<TerrainLayer>>, GridNodeTypeProvider {
    
    public typealias NodeType = TerrainType
    
    public var nodeTypes: [TerrainType] = []
    
    public required override init() {
        
        super.init()
        
        guard let nodeTypes = NodeType.load(filename: "terrain_types") else { fatalError() }
        
        self.nodeTypes = nodeTypes
    }
    
    public required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
}

extension Terrain {
    
    func add(node coordinate: Coordinate) -> TerrainNode<TerrainLayer>? {
        
        return add(node: TerrainTile.fixedVolume(coordinate))
    }
}
