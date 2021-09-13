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
    
    lazy var viewModel: AppViewModel = { return AppViewModel(controller: self) }()
    
    var lastUpdate: TimeInterval?
}

extension AppController: SCNSceneRendererDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        
        let delta = time - (lastUpdate ?? time)
        
        update(delta: delta, time: time)
        
        lastUpdate = time
    }
}

extension AppController {
    
    func update(delta: TimeInterval, time: TimeInterval) {
        
        switch viewModel.state {
            
        case .splash(let controller): controller.update(delta: delta, time: time)
        case .game(let controller): controller.update(delta: delta, time: time)
        default: break
        }
        
        viewModel.scene.update(delta: delta, time: time)
    }
}
