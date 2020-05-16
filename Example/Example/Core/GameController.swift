//
//  GameController.swift
//  Meadow
//
//  Created by Zack Brown on 27/02/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

import SceneKit
import Meadow

#if os(watchOS)

    import WatchKit

#endif

#if os(macOS)

    typealias SCNColor = NSColor

#else

    typealias SCNColor = UIColor

#endif

class GameController: NSObject, SCNSceneRendererDelegate {

    let scene: SCNScene
    let sceneRenderer: SCNView & SCNSceneRenderer
    
    let meadow = Meadow()

    init(sceneRenderer renderer: SCNView & SCNSceneRenderer) {
        
        self.sceneRenderer = renderer
        self.scene = SCNScene()
        
        super.init()
        
        sceneRenderer.delegate = meadow
        sceneRenderer.scene = scene
        sceneRenderer.allowsCameraControl = true
        sceneRenderer.showsStatistics = true
        sceneRenderer.backgroundColor = SCNColor.darkGray
        sceneRenderer.autoenablesDefaultLighting = true

        let cameraNode = SCNNode()
        
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(x: 2.5, y: CGFloat(World.Axis.y(y: World.Constants.floor)), z: 10.0)
        cameraNode.look(at: SCNVector3(x: 0, y: CGFloat(World.Axis.y(y: World.Constants.floor)), z: 0.0))
        
        scene.rootNode.addChildNode(cameraNode)
        scene.rootNode.addChildNode(meadow)
        
        loadScene()
    }
}

extension GameController {
    
    func loadScene() {
        
        DispatchQueue.main.async {
            
            let width = 1
            let depth = 1
            
            for x in 0..<width {
                
                for z in 0..<depth {
                    
                    let coordinate = Coordinate(x: x, y: 0, z: z)
                    
                    self.meadow.terrain.add(tile: coordinate) { layer in
                        
                        layer.color = TerrainLayer.Color(primary: .systemOrange, secondary: .systemPink)
                    }
                }
            }
        }
    }
}
