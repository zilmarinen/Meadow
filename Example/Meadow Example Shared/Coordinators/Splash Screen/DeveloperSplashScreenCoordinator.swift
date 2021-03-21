//
//  DeveloperSplashScreenCoordinator.swift
//
//  Created by Zack Brown on 18/03/2021.
//

import Foundation
import Meadow
import SceneKit
import SpriteKit

class DeveloperSplashScreenCoordinator: ViewCoordinator {
    
    var completion: (() -> Void)?
    
    let timer: Timer
    
    init(controller: GameViewController, duration: TimeInterval) {
        
        self.timer = Timer(duration: duration)
        
        super.init(controller: controller)
    }
    
    required public init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    override func start(with option: StartOption?) {
        
        super.start(with: option)
        
        print("DeveloperSplashScreenCoordinator -> start")
        
        guard let view = controller.view as? SceneView else { return }
        
        view.scene = SCNScene()
        view.isPlaying = true
        
        view.backgroundColor = .systemPink
        
        let node = SKShapeNode(rectOf: CGSize(width: 1, height: 1))
        
        node.fillColor = .systemPurple
        node.blendMode = .multiplyAlpha
        
        let scene = SKScene(size: CGSize(width: 100, height: 100))
        
        scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        scene.scaleMode = .aspectFill
        
        scene.addChild(node)
        
        view.overlaySKScene = scene
    }
}
