//
//  Terrain.swift
//  Meadow
//
//  Created by Zack Brown on 27/04/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

public final class Terrain: Grid<TerrainChunk, TerrainTile, TerrainNode> {

    var terrainTypes: [TerrainType] = []
    
    public required init(delegate: GridDelegate) {
        
        super.init(delegate: delegate)
        
        loadTerrainTypes()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
}

extension Terrain {
    
    public func add(node coordinate: Coordinate) -> TerrainNode? {
        
        let volume = TerrainTile.FixedVolume(coordinate)
        
        if let node = add(node: volume) {
            
            GridEdge.Edges.forEach({ edge in
                
                if let neighbour = find(node: volume.coordinate + GridEdge.Cardinal(edge: edge)) {
                    
                    node.add(neighbour: neighbour, edge: edge)
                }
            })
            
            return node
        }
        
        return nil
    }
    
    public func remove(node: TerrainNode) -> Bool {
        
        if remove(node: node.volume.coordinate) {
        
            GridEdge.Edges.forEach({ edge in
            
                node.remove(neighbour: edge)
            })
            
            return true
        }
        
        return false
    }
}

extension Terrain {
    
    func loadTerrainTypes() {
        
        do {
            
            let path = Bundle.allBundles.path(forResource: "terrain_types", ofType: "json")!
            
            let jsonData = try NSData(contentsOfFile: path) as Data
            
            let decoder = JSONDecoder()
            
            terrainTypes = try decoder.decode([TerrainType].self, from: jsonData)
        }
        catch {
            
            fatalError("Unable to load terrain types")
        }
    }
    
    public func find(terrainType name: String) -> TerrainType? {
        
        return terrainTypes.first { terrainType -> Bool in
            
            return terrainType.name == name
        }
    }
}
