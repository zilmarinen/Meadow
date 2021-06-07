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
    
    var mouseObserver: UUID?
    
    override func start(with option: StartOption?) {
        
        super.start(with: option)
        
        print("SceneCoordinator -> start")
        
        guard let view = controller.view as? ExampleView else { return }
        
        if let scene = option as? Scene {
            
            view.scene = scene
            view.delegate = scene
        }
        else {
            
            guard let asset = NSDataAsset(name: "island_middle") else { fatalError("Unable to load scene") }
            
            do {
                
                let decoder = JSONDecoder()
            
                let meadow = try decoder.decode(Meadow.self, from: asset.data)
            
                let scene = Scene(meadow: meadow)
                
                view.scene = scene
                view.delegate = scene
                view.isPlaying = true
                view.allowsCameraControl = true
                
                if let spawn = meadow.portals.find(portal: .spawn) {
                
                    scene.hero.controller.spawn(at: spawn.coordinate)
                }
            }
            catch {
                
                fatalError("Unable to load scene: \(error)")
            }
        }
        
        view.isPlaying = true
        view.overlaySKScene = nil
        view.backgroundColor = .darkGray
        view.rendersContinuously = true
        
        mouseObserver = view.mouseObserver.subscribe(stateDidChange(from:to:))
    }
    
    override func stop(then completion: CoordinatorCompletionBlock?) {
        
        if let mouseObserver = mouseObserver,
           let view = controller.view as? ExampleView {
            
            view.mouseObserver.unsubscribe(mouseObserver)
        }
        
        super.stop(then: completion)
    }
}

extension SceneCoordinator {
    
    func stateDidChange(from previousState: ExampleView.MouseState?, to currentState: ExampleView.MouseState) {
        
        DispatchQueue.main.async { [weak self] in
                    
            guard let self = self,
                  let view = self.controller.view as? ExampleView,
                  let scene = view.scene as? Scene else { return }
            
            switch currentState {
            
            case .up(let position, let clickType):
                
                let startHit = view.hitTest(point: position.start)
                
                switch clickType {
                
                case .right:
                    print("WOOT")
                    scene.updateSeams()
                
                case .left:
                    
                    guard let surfaceTile = scene.find(traversable: startHit) else { return }
                    
                    scene.hero.controller.move(to: surfaceTile.coordinate)
                
                default: break
                }
                
            default: break
            }
        }
    }
}
