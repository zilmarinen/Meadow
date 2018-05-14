//
//  Terrain.swift
//  Meadow
//
//  Created by Zack Brown on 27/04/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Foundation

/*!
 @class Terrain
 @abstract Terrain is a Grid type that manages the addition and removal of TerrainNodes.
 */
public final class Terrain: Grid<TerrainChunk, TerrainTile, TerrainNode> {

    /*!
     @property terrainTypes
     @abstract Array of TerrainTypes loaded from disc.
     */
    var terrainTypes: [TerrainType] = []
    
    /*!
     @method init:delegate
     @abstract Creates and initialises a grid with the specified delegate.
     @param delegate The delegate to call out to when grid becomes dirty.
     */
    public required init(delegate: GridDelegate) {
        
        super.init(delegate: delegate)
        
        loadTerrainTypes()
    }
    
    /*!
     @method initWithCoder
     @abstract Support coding and decoding via NSKeyedArchiver.
     */
    public required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
}

extension Terrain {
    
    /*!
     @method add:node
     @abstract Attempt to create and return a new grid node at the requested coordinate.
     @param coordinate The coordinate used to define the volume the grid node should occupy.
     */
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
    
    /*!
     @method remove:node
     @abstract Attempt to find and remove the specified node.
     @param node The node to be removed.
     */
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
    
    /*!
     @method loadTerrainTypes
     @abstract Load TerrainTypes from disc.
     */
    func loadTerrainTypes() {
        
        do {
            
            let path = Bundle.meadow.path(forResource: "terrain_types", ofType: "json")!
            
            let jsonData = try NSData(contentsOfFile: path) as Data
            
            let decoder = JSONDecoder()
            
            terrainTypes = try decoder.decode([TerrainType].self, from: jsonData)
        }
        catch {
            
            fatalError("Unable to load terrain types")
        }
    }
    
    /*!
     @method find:terrainType
     @abstract Attempt to find and return the appropriate TerrainType with a matching name.
     @param name The name of the TerrainType to be found and returned.
     */
    public func find(terrainType name: String) -> TerrainType? {
        
        return terrainTypes.first { terrainType -> Bool in
            
            return terrainType.name == name
        }
    }
}
