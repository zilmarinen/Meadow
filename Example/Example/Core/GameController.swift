//
//  GameController.swift
//  Meadow
//
//  Created by Zack Brown on 27/02/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

import SceneKit

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

    init(sceneRenderer renderer: SCNView & SCNSceneRenderer) {
        
        self.sceneRenderer = renderer
        self.scene = SCNScene()
        
        super.init()
        
        sceneRenderer.delegate = self
        sceneRenderer.scene = scene
        sceneRenderer.allowsCameraControl = true
        sceneRenderer.showsStatistics = true
        sceneRenderer.backgroundColor = SCNColor.darkGray
        sceneRenderer.autoenablesDefaultLighting = true

        let cameraNode = SCNNode()
        
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(x: 0.0, y: 0.0, z: 5.0)
        
        scene.rootNode.addChildNode(cameraNode)
    }
}
