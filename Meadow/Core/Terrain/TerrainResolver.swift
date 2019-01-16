//
//  TerrainResolver.swift
//  Meadow
//
//  Created by Zack Brown on 02/08/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

class TerrainResolver: GridResolver {
    
    var volumes: Set<Volume> = []
    
    let terrain: Terrain
    
    let areas: Area
    let footpaths: Footpath
    
    init(terrain: Terrain, areas: Area, footpaths: Footpath) {
        
        self.terrain = terrain
        
        self.areas = areas
        self.footpaths = footpaths
    }
}

extension TerrainResolver {
    
    func resolve() {
        
//        while volumes.count > 0 {
//            
//            let volume = volumes.removeFirst()
//            
//            if let node = terrain.find(node: volume.coordinate), let layer = node.topLayer {
//                
//                clean(node: node, layer: layer)
//                
//                update(node: node, layer: layer)
//            }
//        }
    }
}

extension TerrainResolver {
    
    func clean(node: TerrainNode<TerrainNodeEdge>, layer: TerrainEdgeLayer) {
        
        var staleIntersections: [Polyhedron] = []
        
        for index in 0..<node.totalIntersections {
            
            if let intersection = node.intersection(at: index) {
                
                var stale = true
                
                if layer.upperPolytope.elevation(referencing: intersection.lowerPolytope) == .above {
                    
                    let coordinate = Coordinate(x: node.volume.coordinate.x, y: Axis.Y(y: intersection.lowerPolytope.peak), z: node.volume.coordinate.z)
                    
                    if let areaNode = areas.find(node: coordinate), areaNode.polyhedron == intersection {
                        
                        stale = false
                    }
                    
                    if stale, let footpathNode = footpaths.find(node: coordinate), footpathNode.polyhedron == intersection {
                        
                        stale = false
                    }
                }
                
                if stale {
                    
                    staleIntersections.append(intersection)
                }
            }
        }
        
        staleIntersections.forEach { polyhedron in
            
            let _ = node.remove(intersection: polyhedron)
        }
    }
    
    func update(node: TerrainNode<TerrainNodeEdge>, layer: TerrainEdgeLayer) {
        
        if let areaTile = areas.find(tile: node.volume.coordinate) {
            
            for index in 0..<areaTile.totalChildren {
                
                if let areaNode = areaTile.child(at: index) as? AreaNode, layer.upperPolytope.elevation(referencing: areaNode.polyhedron.lowerPolytope) == .above {
                    
                    if node.find(intersection: areaNode.polyhedron) == nil {
                     
                        let _ = node.add(intersection: areaNode.polyhedron)
                    }
                }
            }
        }
        
        if let footpathTile = footpaths.find(tile: node.volume.coordinate) {
            
            for index in 0..<footpathTile.totalChildren {
                
                if let footpathNode = footpathTile.child(at: index) as? FootpathNode, layer.upperPolytope.elevation(referencing: footpathNode.polyhedron.lowerPolytope) == .above {
                    
                    if node.find(intersection: footpathNode.polyhedron) == nil {
                        
                        let _ = node.add(intersection: footpathNode.polyhedron)
                    }
                }
            }
        }
    }
}
