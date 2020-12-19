//
//  GameViewController+Shared.swift
//  Meadow Example
//
//  Created by Zack Brown on 15/12/2020.
//

import Meadow
import SceneKit

extension GameViewController {
    
    func setupScene() {
        
        guard let sceneView = view as? SCNView else { fatalError("Invalid view hierarchy") }
        
        let scene = Scene(season: .spring)
        
        let box = SCNBox(width: 1, height: 1, length: 1, chamferRadius: 0)
        
        let node = SCNNode(geometry: box)
        
        box.firstMaterial?.diffuse.contents = MDWColor.systemPink
        
        scene.rootNode.addChildNode(node)
        
        sceneView.scene = scene
        sceneView.delegate = scene
        sceneView.allowsCameraControl = true
        sceneView.isPlaying = true
        sceneView.autoenablesDefaultLighting = true
        
        let x = 3
        let z = 4
        let width = 10
        let depth = 10
        
        let band0 = 2
        let baseType = TerrainTileType.dirt
        
        for x in 0..<width {
            
            for z in 0..<depth {
                
                var tileType = baseType.next
                
                if x < band0 || x >= (width - band0) || z < band0 || z >= (depth - band0) {
                    
                    tileType = baseType
                }
                
                _ = scene.meadow.terrain.add(tile: Coordinate(x: x, y: 0, z: z)) { tile in
                    
                    tile.tileType = tileType
                }
            }
        }
        
        //
        //
        //
        
        if let tile = scene.meadow.terrain.find(tile: Coordinate(x: x, y: 0, z: z)) {
            
            tile.slope = .west
        }
        
        if let tile = scene.meadow.terrain.find(tile: Coordinate(x: x, y: 0, z: z + 1)) {
            
            tile.slope = .west
        }
        
        //
        //
        //
        
        if let tile = scene.meadow.terrain.find(tile: Coordinate(x: x + 1, y: 0, z: z)) {
            
            tile.coordinate = Coordinate(x: tile.coordinate.x, y: 1, z: tile.coordinate.z)
        }
        
        if let tile = scene.meadow.terrain.find(tile: Coordinate(x: x + 1, y: 0, z: z + 1)) {
            
            tile.coordinate = Coordinate(x: tile.coordinate.x, y: 1, z: tile.coordinate.z)
        }
        
        if let tile = scene.meadow.terrain.find(tile: Coordinate(x: x + 1, y: 0, z: z - 1)) {
            
            tile.slope = .north
        }
        
        //
        //
        //
        
        if let tile = scene.meadow.terrain.find(tile: Coordinate(x: x + 2, y: 0, z: z)) {
            
            tile.coordinate = Coordinate(x: tile.coordinate.x, y: 1, z: tile.coordinate.z)
            tile.slope = .west
        }
        
        //
        //  Footpath
        //
        
        let _ = scene.meadow.footpath.add(tile: Coordinate(x: x - 1, y: 0, z: z - 1)) { tile in tile.tileType = .wood}
        let _ = scene.meadow.footpath.add(tile: Coordinate(x: x - 1, y: 0, z: z)) { tile in tile.tileType = .wood}
        let _ = scene.meadow.footpath.add(tile: Coordinate(x: x - 1, y: 0, z: z + 1)) { tile in tile.tileType = .wood}

        _ = scene.meadow.footpath.add(tile: Coordinate(x: x, y: 0, z: z)) { tile in

            tile.tileType = .wood
            tile.slope = .west
        }

        _ = scene.meadow.footpath.add(tile: Coordinate(x: x + 1, y: 0, z: z)) { tile in

            tile.tileType = .wood
            tile.coordinate = Coordinate(x: tile.coordinate.x, y: 1, z: tile.coordinate.z)
        }
        
        _ = scene.meadow.footpath.add(tile: Coordinate(x: x + 1, y: 0, z: z + 1)) { tile in

            tile.tileType = .wood
            tile.coordinate = Coordinate(x: tile.coordinate.x, y: 1, z: tile.coordinate.z)
        }
        
        let _ = scene.meadow.footpath.add(tile: Coordinate(x: x - 2, y: 0, z: z)) { tile in tile.tileType = .wood}
        let _ = scene.meadow.footpath.add(tile: Coordinate(x: x - 2, y: 0, z: z + 1)) { tile in tile.tileType = .wood}
        
        let _ = scene.meadow.footpath.add(tile: Coordinate(x: x - 3, y: 0, z: z)) { tile in tile.tileType = .wood}
        
        let _ = scene.meadow.footpath.add(tile: Coordinate(x: x - 1, y: 0, z: z + 2)) { tile in tile.tileType = .wood}
        let _ = scene.meadow.footpath.add(tile: Coordinate(x: x, y: 0, z: z + 2)) { tile in tile.tileType = .wood}
        let _ = scene.meadow.footpath.add(tile: Coordinate(x: x + 1, y: 0, z: z + 2)) { tile in tile.tileType = .wood}
        let _ = scene.meadow.footpath.add(tile: Coordinate(x: x + 2, y: 0, z: z + 2)) { tile in tile.tileType = .wood}
        
        /*
        let size = 20
        let water = 2
        let sand = 4
        let dirt = 6
        let grass = 8
        
        for x in 0..<size {
            
            for z in 0..<size {
                
                var tileType = TerrainTileType.undergrowth
                
                if x <= (water - 1) || x >= (size - water) || z <= (water - 1) || z >= (size - water) {
                    
                    tileType = .water
                }
                else if x <= (sand - 1) || x >= (size - sand) || z <= (sand - 1) || z >= (size - sand) {

                    tileType = .sand
                }
                else if x <= (dirt - 1) || x >= (size - dirt) || z <= (dirt - 1) || z >= (size - dirt) {

                    tileType = .dirt
                }
                else if x <= (grass - 1) || x >= (size - grass) || z <= (grass - 1) || z >= (size - grass) {

                    tileType = .grass
                }
                
                let _ = scene.meadow.terrain.add(tile: Coordinate(x: x, y: 0, z: z), layer: tileType)
            }
        }*/
    }
}
