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
        
        let meadow = Meadow(graph: Graph(rings: 10, size: 1.0, iterations: 1))
        
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
    }
}

extension GameController {
    
    func loadScene(meadow: Meadow) {
        
        DispatchQueue.main.async {
            
//            let n0 = SCNNode(geometry: SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0))
//
//            n0.geometry?.firstMaterial?.diffuse.contents = SKColor.systemPink
//
//            self.scene.rootNode.addChildNode(n0)
            
//            guard let totalQuads = self.scene.meadow.terrain.graph?.totalQuads else { return }
//
//            for index in 0..<totalQuads {
//
//                self.scene.meadow.terrain.add(tile: index)?.children.forEach { child in
//
//                    if let child = child as? TerrainEdge {
//
//                        child.topLayer?.terrainType = .bedrock
//
//                        child.addLayer()
//
//                        child.topLayer?.terrainType = .grass
//                        child.topLayer?.set(elevation: 2)
//                    }
//                }
//            }
        }
    }
}
