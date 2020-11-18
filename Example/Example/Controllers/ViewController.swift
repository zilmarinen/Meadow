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
        
        let size = 12
        
        for x in 0..<size {
            
            for z in 0..<size {
                
                var tileType = TerrainTileType.undergrowth
                
                if x == 0 || x == (size - 1) || z == 0 || z == (size - 1) {
                    
                    tileType = .water
                }
                else if x == 1 || x == (size - 2) || z == 1 || z == (size - 2) {
                    
                    tileType = .sand
                }
                else if x == 2 || x == (size - 3) || z == 2 || z == (size - 3) {
                    
                    tileType = .dirt
                }
                else if x == 3 || x == (size - 4) || z == 3 || z == (size - 4) {
                    
                    tileType = .grass
                }
                
                let _ = scene.meadow.terrain.add(tile: Coordinate(x: x, y: 0, z: z), tileType: tileType)
            }
        }
    }
}
