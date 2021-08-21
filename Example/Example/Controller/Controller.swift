//
//  Controller.swift
//
//  Created by Zack Brown on 18/08/2021.
//

import Foundation
import Meadow
import SceneKit
import SwiftUI

class Controller: NSObject, ObservableObject, Updatable {
    
    enum State {
        
        case application(Stopwatch)
        case developer(Stopwatch)
        case loading
        case scene
    }
    
    @Published private(set) var state: State = .developer(Stopwatch(duration: 1))
    @Published var scene: MDWScene?
    var lastUpdate: TimeInterval?
}

extension Controller: SCNSceneRendererDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        
        let delta = time - (lastUpdate ?? time)
        
        DispatchQueue.main.async {
            
            self.update(delta: delta, time: time)
        }
        
        lastUpdate = time
    }
}

extension Controller {
    
    func update(delta: TimeInterval, time: TimeInterval) {
        
        switch state {
            
        case .application(let timer):
            
            guard timer.integrate(delta: delta) else { break }
            
            state = .loading
            
        case .developer(let timer):
            
            guard timer.integrate(delta: delta) else { break }
            
            state = .application(Stopwatch(duration: timer.duration))
        
        case .loading:
            
            guard let asset = NSDataAsset(name: "island") else { fatalError("Unable to load scene") }

            do {

                let meadow = try JSONDecoder().decode(Meadow.self, from: asset.data)

                self.scene = MDWScene(meadow: meadow)

                let device = MTLCreateSystemDefaultDevice()

                scene?.library = try device?.makeDefaultLibrary(bundle: Meadow.bundle)

                state = .scene
            }
            catch {

                fatalError("Unable to load scene: \(error)")
            }
            
        case .scene:
            
            scene?.update(delta: delta, time: time)
        }
    }
}
