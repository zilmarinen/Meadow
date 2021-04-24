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
            
            guard let asset = NSDataAsset(name: "island_1") else { fatalError("Unable to load scene") }
            
            let decoder = JSONDecoder()
            
            do {
            
                let scene = try decoder.decode(Scene.self, from: asset.data)
            
                view.scene = scene
                view.delegate = scene
                view.isPlaying = true
            }
            catch {
                
                fatalError("Unable to load scene: \(error)")
            }
        }
        
        view.isPlaying = true
        view.overlaySKScene = nil
        
        view.backgroundColor = .white
    }
}
