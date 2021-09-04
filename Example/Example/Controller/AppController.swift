//
//  AppController.swift
//
//  Created by Zack Brown on 18/08/2021.
//

import Foundation
import Meadow
import SceneKit
import SwiftUI

class AppController: NSObject, ObservableObject, Updatable {
    
    enum State {
        
        case splash(SplashController)
        case game(GameController)
    }
    
    lazy var scene: MDWScene = {
        
        let s = MDWScene()
        
        let d = MTLCreateSystemDefaultDevice()
        
        s.library = try? d?.makeDefaultLibrary(bundle: Map.bundle)
        
        return s
    }()
    
    @Published private(set) var state: State
    
    var lastUpdate: TimeInterval?
    
    override init() {
        
        let controller = SplashController()
        
        self.state = .splash(controller)
        
        super.init()
        
        controller.parent = self
    }
}

extension AppController: SCNSceneRendererDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        
        let delta = time - (lastUpdate ?? time)
        
        DispatchQueue.main.async {
            
            self.update(delta: delta, time: time)
        }
        
        lastUpdate = time
    }
}

extension AppController {
    
    func update(delta: TimeInterval, time: TimeInterval) {
        
        switch state {
            
        case .splash(let controller): controller.update(delta: delta, time: time)
        case .game(let controller): controller.update(delta: delta, time: time)
        }
        
        scene.update(delta: delta, time: time)
    }
}

extension AppController {
    
    func handle(input tap: CGPoint) {
        
        print("Tap: \(tap)")
    }
}

extension AppController {
    
    func loadGame() {
        
        DispatchQueue.main.async { [weak self] in
            
            guard let self = self else { return }
            
            let controller = GameController(parent: self, hero: Hero())
            
            self.state = .game(controller)
        }
    }
}
