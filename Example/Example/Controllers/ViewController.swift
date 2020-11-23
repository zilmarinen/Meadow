//
//  ViewController.swift
//  Example
//
//  Created by Zack Brown on 16/11/2020.
//

import Cocoa
import Meadow
import SceneKit

class ViewController: NSViewController {
    
    @IBOutlet weak var sceneView: SCNView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        let scene = Scene()
        
        scene.camera.camera?.usesOrthographicProjection = true
        scene.camera.position = SCNVector3(x: 0, y: 20, z: 20)
        scene.camera.look(at: scene.meadow.position)
        
        sceneView.scene = scene
        sceneView.delegate = scene
        sceneView.allowsCameraControl = true
        sceneView.isPlaying = true
        sceneView.autoenablesDefaultLighting = true
        /*
        let tiles = [Coordinate(x: 0, y: 0, z: 0): TerrainTileType.sand,
        
                     Coordinate(x: 1, y: 0, z: 0): TerrainTileType.sand,   //west
                     Coordinate(x: -1, y: 0, z: 0): TerrainTileType.sand,  //east
                     Coordinate(x: 0, y: 0, z: 1): TerrainTileType.water,   //north
                     Coordinate(x: 0, y: 0, z: -1): TerrainTileType.sand]  //south
        
        for (coordinate, tileType) in tiles {
            
            if let tile = scene.meadow.terrain.add(tile: coordinate, tileType: tileType) {
                
                if tile.coordinate.x == -1 {
                    
                    //tile.slope = .east
                }
            }
        }*/
        
        
        let width = 5
        let depth = 3
        
        for x in 0..<width {
            
            for z in 0..<depth {
                
                let _ = scene.meadow.terrain.add(tile: Coordinate(x: x, y: 0, z: z), tileType: .grass)
            }
        }
        
        if let tile = scene.meadow.terrain.find(tile: Coordinate(x: 1, y: 0, z: 1)) {
            
            tile.slope = .west
        }
        
        if let tile = scene.meadow.terrain.find(tile: Coordinate(x: 2, y: 0, z: 1)) {
            
            tile.slope = .west
            tile.coordinate = Coordinate(x: 2, y: 1, z: 1)
        }
        
        if let tile = scene.meadow.terrain.find(tile: Coordinate(x: 3, y: 0, z: 1)) {
            
            tile.coordinate = Coordinate(x: 3, y: 2, z: 1)
        }
        
        
//        let box = SCNBox(width: 1.0, height: 1.0, length: 1.0, chamferRadius: 0.0)
//        box.firstMaterial?.diffuse.contents = MDWColor.systemRed
//        let node = SCNNode(geometry: box)
//        scene.rootNode.addChildNode(node)
        
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
                
                let _ = scene.meadow.terrain.add(tile: Coordinate(x: x, y: 0, z: z), tileType: tileType)
            }
        }*/
    }
}
