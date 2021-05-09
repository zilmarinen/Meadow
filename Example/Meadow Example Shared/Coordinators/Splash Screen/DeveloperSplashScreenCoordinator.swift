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
        
        guard let view = controller.view as? ExampleView else { return }
        
        view.scene = SCNScene()
        view.delegate = self
        view.isPlaying = true
        
        view.backgroundColor = .systemPink
        
        let node = SKSpriteNode(imageNamed: "developer_splash")
        
        node.scale(to: CGSize(width: node.size.width / 4, height: node.size.height / 4))
        
        let scene = SKScene(size: view.frame.size)
        
        scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        scene.scaleMode = .aspectFill
        
        scene.addChild(node)
        
        view.overlaySKScene = scene
    }
    
    override func update(delta: TimeInterval, time: TimeInterval) {
        
        guard timer.integrate(delta: delta) else { return }
        
        DispatchQueue.main.sync { [weak self] in
            
            guard let self = self,
                  let view = controller.view as? ExampleView else { return }
            
            view.delegate = nil
            
            self.completion?()
        }
    }
}
