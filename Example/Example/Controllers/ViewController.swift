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
        scene.camera.position = SCNVector3(x: 5, y: 5, z: 5)
        scene.camera.look(at: scene.meadow.position)
        
        sceneView.scene = scene
        sceneView.delegate = scene
        sceneView.allowsCameraControl = true
        sceneView.isPlaying = true
        
        let size = 6
        let margin = 1
        
        for x in 0..<size {
            
            for z in 0..<size {
                
                let _ = scene.meadow.terrain.add(tile: Coordinate(x: x, y: 0, z: z), tileType: .dirt)
            }
        }
        
        for x in margin..<(size - margin) {

            for z in margin..<(size - margin) {

                if let tile = scene.meadow.terrain.find(tile: Coordinate(x: x, y: 0, z: z)) {

                    tile.set(tileType: .grass)
                }
            }
        }
        
        if let tile = scene.meadow.terrain.find(tile: Coordinate(x: 3, y: 0, z: 3)) {
            
            tile.set(tileType: .undergrowth)
        }
    }
}
