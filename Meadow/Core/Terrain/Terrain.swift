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
        
        do {
            
            let path = Bundle.meadow.path(forResource: "terrain_types", ofType: "json")!
            
            let jsonData = try NSData(contentsOfFile: path) as Data
            
            let decoder = JSONDecoder()
            
            nodeTypes = try decoder.decode([TerrainType].self, from: jsonData)
        }
        catch {
            
            fatalError("Unable to load terrain types")
        }
    }
    
    public required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
}

extension Terrain {
    
    func add(node coordinate: Coordinate) -> TerrainNode<TerrainLayer>? {
        
        return add(node: TerrainTile.FixedVolume(coordinate))
    }
}
