//
//  GameContoller.swift
//
//  Created by Zack Brown on 26/08/2021.
//

import Foundation
import Meadow
import SwiftUI

struct Hero: Hashable {
    
    let name = "Zachy"
}

class GameController: ObservableObject, Updatable {
    
    weak private(set) var parent: AppController?
    
    @ObservedObject var viewModel: GameViewModel
    
    init(parent: AppController, hero: Hero) {
        
        self.parent = parent
        self.viewModel = GameViewModel(initialState: .initialising(hero))
    }
}

extension GameController {
    
    func update(delta: TimeInterval, time: TimeInterval) {
        
        //
    }
}
/*
extension GameController {
    
    func load(hero: Hero) {
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
        
            guard let self = self,
                  let map = try? Map.map(named: "island") else { fatalError("Unable to load map") }
        
            self.load(map: map, hero: hero)
        }
    }
    
    func load(map: Map, hero: Hero) {
        
        guard let scene = parent?.scene else { return }
     
//        scene.load(map: map) { progress, category in
//
//            DispatchQueue.main.async { [weak self] in
//
//                guard let self = self else { return }
//
//                self.state = .loading(map, progress, category)
//
//                guard progress >= 1.0 else { return }
//
//                self.show(map: map, hero: hero)
//            }
//        }
    }
    
    func show(map: Map, hero: Hero) {
        
        DispatchQueue.main.async { [weak self] in
            
            guard let self = self,
                  let scene = self.parent?.scene else { return }
            
            if let spawn = map.portals.find(portal: .spawn) {
                
                scene.protagonist.controller.spawn(at: spawn.coordinate)
                scene.protagonist.isHidden = false
            }
            
            let controller = SceneController(parent: self, map: map, hero: hero)
            
            self.state = .scene(controller)
        }
    }
}
*/
