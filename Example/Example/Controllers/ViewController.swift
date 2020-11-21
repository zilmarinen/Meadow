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
        scene.camera.position = SCNVector3(x: -20, y: 20, z: -20)
        scene.camera.look(at: scene.meadow.position)
        
        sceneView.scene = scene
        sceneView.delegate = scene
        sceneView.allowsCameraControl = true
        sceneView.isPlaying = true
        
        let width = 5
        let depth = 3
        
        for x in 0..<width {
            
            for z in 0..<depth {
                
                let _ = scene.meadow.terrain.add(tile: Coordinate(x: x, y: 0, z: z), tileType: .grass)
            }
        }
        
        if let tile = scene.meadow.terrain.find(tile: Coordinate(x: 1, y: 0, z: 1)) {
            
            tile.slope = .east
        }
        
        if let tile = scene.meadow.terrain.find(tile: Coordinate(x: 2, y: 0, z: 1)) {
            
            tile.slope = .east
            tile.coordinate = Coordinate(x: 2, y: 1, z: 1)
        }
        
        if let tile = scene.meadow.terrain.find(tile: Coordinate(x: 3, y: 0, z: 1)) {
            
            tile.coordinate = Coordinate(x: 3, y: 2, z: 1)
        }
        
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
