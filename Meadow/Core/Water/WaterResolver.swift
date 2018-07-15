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
        
        volumes.forEach { volume in
            
            if let terrainNode = terrain.find(node: volume.coordinate), let terrainLayer = terrainNode.topLayer {
                
                let existingWaterNode = water.find(node: volume.coordinate)
                
                let terrainLevel = World.Y(y: terrainLayer.polyhedron.upperPolytope.base)
                
                let surroundingWaterLevel = waterLevel(surrounding: volume.coordinate)
                
                let existingWaterLevel = existingWaterNode != nil ? existingWaterNode!.waterLevel : terrainLevel
                
                let maximumWaterLevel = max(existingWaterLevel, surroundingWaterLevel)
                
                if maximumWaterLevel > terrainLevel {
                    
                    let waterNode = existingWaterNode ?? water.add(node: volume.coordinate)
                    
                    if let waterNode = waterNode {
                        
                        waterNode.waterLevel = maximumWaterLevel
                        waterNode.basePolytope = terrainNode.topLayer?.polyhedron.upperPolytope
                    }
                }
                else {
                    
                    water.remove(tile: volume.coordinate)
                }
            }
            else {
                
                water.remove(tile: volume.coordinate)
            }
        }
        
        volumes.removeAll()
    }
}

extension WaterResolver {
    
    /*!
     @method waterLevel:surrounding:coordinate
     @abstract return the highest water level of any surrounding WaterNodes.
     @param coordinate The Coordinate whose neighbouring GridNodes should be checked.
     */
    func waterLevel(surrounding coordinate: Coordinate) -> Int {
        
        var waterLevel = World.Floor
        
        GridEdge.Edges.forEach { edge in
            
            let neighbourCoordinate = coordinate + GridEdge.Extent(edge: edge)
            
            if terrain.find(node: neighbourCoordinate) != nil {
                
                if let waterNeighbour = water.find(node: neighbourCoordinate) {
                    
                    waterLevel = max(waterLevel, waterNeighbour.waterLevel)
                }
            }
        }
        
        return waterLevel
    }
}
