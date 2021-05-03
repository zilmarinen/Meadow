//
//  SceneCoordinator.swift
//
//  Created by Zack Brown on 29/03/2021.
//

import Foundation
import Meadow
import SceneKit
import SpriteKit

class SceneCoordinator: ViewCoordinator {
    
    override func start(with option: StartOption?) {
        
        super.start(with: option)
        
        print("SceneCoordinator -> start")
        
        guard let view = controller.view as? SceneView else { return }
        
        if let scene = option as? Scene {
            
            view.scene = scene
            view.delegate = scene
        }
        else {
            
            guard let asset = NSDataAsset(name: "m0") else { fatalError("Unable to load scene") }
            
            do {
                
                let decoder = JSONDecoder()
            
                let meadow = try decoder.decode(Meadow.self, from: asset.data)
            
                let scene = Scene(meadow: meadow)
                
                view.scene = scene
                view.delegate = self
                view.isPlaying = true
                view.allowsCameraControl = true
                
                scene.hero.controller.spawn(at: Coordinate(x: 0, y: 10, z: 0))
            }
            catch {
                
                fatalError("Unable to load scene: \(error)")
            }
        }
        
        view.isPlaying = true
        view.overlaySKScene = nil
        
        view.backgroundColor = .white
    }
    
    override func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        
        super.renderer(renderer, updateAtTime: time)
        
        DispatchQueue.main.async {
         
            guard let view = self.controller.view as? SceneView,
                  let scene = view.scene as? Scene else { return }
            
            scene.renderer(renderer, updateAtTime: time)
            
            switch scene.hero.controller.state {
            
            case .idle:
                
                guard let portal = scene.meadow.portals.find(portal: "m0p0") ??
                        scene.meadow.portals.find(portal: "m2p0") ??
                        scene.meadow.portals.find(portal: "m3p0") ??
                        scene.meadow.portals.find(portal: "m3p0") else { return }
                
                scene.hero.controller.move(to: portal.coordinate + portal.segue.direction.coordinate)
                
            default: break
            }
        }
    }
}
