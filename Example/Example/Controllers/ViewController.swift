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
        
        let x = 3
        let z = 4
        let width = 9
        let depth = 9
        
        let box = SCNBox(width: 0.20, height: 0.50, length: 0.20, chamferRadius: 0.0)
        box.firstMaterial?.diffuse.contents = MDWColor.systemPink
        let node = SCNNode(geometry: box)
        node.position = SCNVector3(x: CGFloat(x + 1), y: 0.75, z: CGFloat(z))
        scene.rootNode.addChildNode(node)
        
        scene.camera.look(at: node.position)
        
        let band0 = 2
        let baseType = TerrainTileType.dirt
        
        for x in 0..<width {
            
            for z in 0..<depth {
                
                var tileType = baseType.next
                
                if x < band0 || x >= (width - band0) || z < band0 || z >= (depth - band0) {
                    
                    tileType = baseType
                }
                
                let _ = scene.meadow.terrain.add(tile: Coordinate(x: x, y: 0, z: z), layer: tileType)
            }
        }
        
        //
        //
        //
        
        if let tile = scene.meadow.terrain.find(tile: Coordinate(x: x, y: 0, z: z)) {
            
            tile.layer.slope = .west
        }
        
        if let tile = scene.meadow.terrain.find(tile: Coordinate(x: x, y: 0, z: z + 1)) {
            
            tile.layer.slope = .west
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
            
            tile.layer.slope = .north
        }
        
        //
        //
        //
        
        if let tile = scene.meadow.terrain.find(tile: Coordinate(x: x + 2, y: 0, z: z)) {
            
            tile.coordinate = Coordinate(x: tile.coordinate.x, y: 1, z: tile.coordinate.z)
            tile.layer.slope = .west
        }
        
        //
        //  Footpath
        //
        
        let _ = scene.meadow.footpath.add(tile: Coordinate(x: x - 1, y: 0, z: z - 1), layer: .wood)
        let _ = scene.meadow.footpath.add(tile: Coordinate(x: x - 1, y: 0, z: z), layer: .wood)
        let _ = scene.meadow.footpath.add(tile: Coordinate(x: x - 1, y: 0, z: z + 1), layer: .wood)

        if let path = scene.meadow.footpath.add(tile: Coordinate(x: x, y: 0, z: z), layer: .wood) {

            path.layer.slope = .west
        }

        if let path = scene.meadow.footpath.add(tile: Coordinate(x: x + 1, y: 0, z: z), layer: .wood) {

            path.coordinate = Coordinate(x: path.coordinate.x, y: 1, z: path.coordinate.z)
        }
        
        if let path = scene.meadow.footpath.add(tile: Coordinate(x: x + 1, y: 0, z: z + 1), layer: .wood) {

            path.coordinate = Coordinate(x: path.coordinate.x, y: 1, z: path.coordinate.z)
        }
        
        let _ = scene.meadow.footpath.add(tile: Coordinate(x: x - 2, y: 0, z: z), layer: .wood)
        let _ = scene.meadow.footpath.add(tile: Coordinate(x: x - 2, y: 0, z: z + 1), layer: .wood)
        
        let _ = scene.meadow.footpath.add(tile: Coordinate(x: x - 3, y: 0, z: z), layer: .wood)
        
        let _ = scene.meadow.footpath.add(tile: Coordinate(x: x - 1, y: 0, z: z + 2), layer: .wood)
        let _ = scene.meadow.footpath.add(tile: Coordinate(x: x, y: 0, z: z + 2), layer: .wood)
        let _ = scene.meadow.footpath.add(tile: Coordinate(x: x + 1, y: 0, z: z + 2), layer: .wood)
        let _ = scene.meadow.footpath.add(tile: Coordinate(x: x + 2, y: 0, z: z + 2), layer: .wood)
        
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
