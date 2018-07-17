//
//  WaterResolver.swift
//  Meadow-iOS
//
//  Created by Zack Brown on 14/07/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

/*!
 @protocol WaterResolver
 @abstract A WaterResolver is responsible for flood filling and removing neighbouring WaterNodes when TerrainNode changes are propagated.
 */
public class WaterResolver: GridResolver {
    
    /*!
     @property water
     @abstract Water Grid type.
     */
    let water: Water
    
    /*!
     @property terrain
     @abstract Terrain Grid type.
     */
    let terrain: Terrain
    
    /*!
     @property volumes
     @abstract A set of unique volumes to be resolved.
     */
    public var volumes: Set<Volume>
    
    /*!
     @method init:water:terrain
     @abstract Creates and initialises a resolver with the specified grid.
     @param water The Water Grid to resolve.
     @param terrain The Terrain Grid data source.
     */
    init(water: Water, terrain: Terrain) {
        
        self.water = water
        
        self.terrain = terrain
        
        self.volumes = Set<Volume>()
    }
    
    /*!
     @method resolve
     @astract Resolve any enqueued volume changes.
     */
    public func resolve() {
        
        if volumes.count > 0 {
            
            let volume = volumes.removeFirst()
            
            let coordinate = volume.coordinate
            
            let terrainNode = terrain.find(node: coordinate)
            
            if terrainNode == nil {
                
                water.remove(node: coordinate)
                
                return
            }
            
            if let waterNode = water.find(node: coordinate) {
                
                waterNode.waterLevel = max(waterNode.waterLevel, waterLevel(surrounding: coordinate))
                waterNode.basePolytope = terrainNode?.topLayer?.polyhedron.upperPolytope
                
                if let waterType = waterNode.waterType {
                    
                    GridEdge.Edges.forEach { edge in
                    
                        let waterNodeNeighbour = waterNode.find(neighbour: edge)?.node as? WaterNode
                        
                        if waterNodeNeighbour == nil || waterNodeNeighbour!.waterLevel < waterNode.waterLevel {
                         
                            flood(coordinate: coordinate + GridEdge.Extent(edge: edge), waterLevel: waterNode.waterLevel, waterType: waterType)
                        }
                    }
                }
            }
        }
    }
}

extension WaterResolver {
    
    /*!
     @method
     @abstract
     @param
     */
    func flood(coordinate: Coordinate, waterLevel: Int, waterType: WaterType) {
        
        if let terrainLayer = terrain.find(node: coordinate)?.topLayer, World.Y(y: terrainLayer.polyhedron.upperPolytope.base) < waterLevel {
            
            if let waterNode = water.find(node: coordinate) ?? water.add(node: coordinate) {
                
                waterNode.waterType = waterType
                waterNode.waterLevel = waterLevel
                waterNode.basePolytope = terrainLayer.polyhedron.upperPolytope
            }
        }
    }
    
    /*!
     @method
     @abstract
     @param
     */
    func waterLevel(surrounding coordinate: Coordinate) -> Int {
        
        var level = World.Floor
        
        GridEdge.Edges.forEach { edge in
         
            if let waterNode = water.find(node: coordinate + GridEdge.Extent(edge: edge)) {
                
                level = max(level, waterNode.waterLevel)
            }
        }
        
        return level
    }
}
