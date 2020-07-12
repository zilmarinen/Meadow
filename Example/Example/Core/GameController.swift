//
//  GameController.swift
//  Meadow
//
//  Created by Zack Brown on 27/02/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

import Meadow
import Pasture
import SceneKit
import Terrace

class GameController: NSObject {

    let sceneView: SceneView
    
    let scene: Scene
    
    init(sceneRenderer renderer: SceneView & SCNSceneRenderer) {
        
        do {
            
            guard let device = renderer.device else { fatalError("Invalid device for SceneView") }
            
            guard let path = Meadow.bundle?.path(forResource: "Meadow", ofType: "metallib") else { fatalError("Missing required Meadow.metallib") }
            
            Stage.shaderLibrary = try device.makeLibrary(filepath: path)
        }
        catch {
            
            fatalError("Unable to make Meadow.metallib default device program library: \(error)")
        }
        
        let meadow = Meadow()
        
        meadow.floor.rendersGridLines = true
        meadow.floor.backgroundColor = .white
        meadow.floor.gridColor = .black
        
        self.sceneView = renderer
        self.scene = Scene(meadow: meadow)
        
        super.init()
        
        sceneView.delegate = self
        sceneView.scene = scene
        sceneView.allowsCameraControl = true
        sceneView.showsStatistics = true
        sceneView.backgroundColor = SKColor.black
        sceneView.autoenablesDefaultLighting = false
        sceneView.isPlaying = true
        
        loadScene(meadow: meadow)
    }
}

extension GameController: SCNSceneRendererDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        
        scene.renderer(renderer, updateAtTime: time)
        
        DispatchQueue.main.async {
            
            switch self.sceneView.keyboardObserver.state {
                
            case .keysHeld(let keys):
                
                keys.forEach { key in
                    
                    switch key {
                        
                    case .w: self.scene.camera.observer.focus(vector: SCNVector3(x: -1, y: 0, z: 0))
                    case .a: self.scene.camera.observer.focus(vector: SCNVector3(x: 1, y: 0, z: 0))
                    case .s: self.scene.camera.observer.focus(vector: SCNVector3(x: 0, y: 0, z: 1))
                    case .d: self.scene.camera.observer.focus(vector: SCNVector3(x: 0, y: 0, z: -1))
                    default: break
                    }
                }
                
            default: break
            }
        }
    }
}

extension GameController {
    
    func loadScene(meadow: Meadow) {
        
        DispatchQueue.main.async {
            
            let width = 1
            let depth = 1
            
            for x in 0..<width {
                
                for z in 0..<depth {
                    
                    let coordinate = Coordinate(x: x, y: 0, z: z)
                    let _ = meadow.terrain.add(tile: coordinate)
                    
                    if x >= 1 && x < (width - 1) && z >= 1 && z < (depth - 1) {
                    
                        let waterTile = meadow.water.add(tile: coordinate)
                        
                        let l0 = waterTile.add(edge: .north).addLayer()
                        let l1 = waterTile.add(edge: .east).addLayer()
                        let l2 = waterTile.add(edge: .south).addLayer()
                        let l3 = waterTile.add(edge: .west).addLayer()
                    
                        l0?.set(elevation: 2)
                        l1?.set(elevation: 2)
                        l2?.set(elevation: 2)
                        l3?.set(elevation: 2)
                    }
                }
            }
            
            let n0 = SCNNode(geometry: SCNBox(width: 0.5, height: 1, length: 0.5, chamferRadius: 0))
            let n1 = SCNNode(geometry: SCNBox(width: 0.5, height: 1, length: 0.5, chamferRadius: 0))
            let n2 = SCNNode(geometry: SCNBox(width: 0.5, height: 1, length: 0.5, chamferRadius: 0))
            
            n0.position = SCNVector3(x: 0.0, y: CGFloat(World.Axis.y(value: World.Constants.floor) + 0.5), z: 0.0)
            n1.position = SCNVector3(x: 1.0, y: CGFloat(World.Axis.y(value: World.Constants.floor) + 0.5), z: 0.0)
            n2.position = SCNVector3(x: 2.0, y: CGFloat(World.Axis.y(value: World.Constants.floor) + 0.5), z: 0.0)
            
            n0.geometry?.firstMaterial?.diffuse.contents = SKColor.systemPink
            n1.geometry?.firstMaterial?.diffuse.contents = SKColor.systemOrange
            n2.geometry?.firstMaterial?.diffuse.contents = SKColor.systemPurple
            
            self.scene.rootNode.addChildNode(n0)
            self.scene.rootNode.addChildNode(n1)
            self.scene.rootNode.addChildNode(n2)
        }
    }
}
