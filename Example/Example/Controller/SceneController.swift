//
//  SceneController.swift
//
//  Created by Zack Brown on 27/08/2021.
//

import Foundation
import Meadow

class SceneController: ObservableObject, Updatable {
    
    enum State: Hashable {
        
        case scene(Map, Hero)
    }
    
    weak private(set) var parent: GameController?
    
    @Published private(set) var state: State
    
    init(parent: GameController, map: Map, hero: Hero) {
        
        self.parent = parent
        self.state = .scene(map, hero)
    }
}

extension SceneController {
    
    func update(delta: TimeInterval, time: TimeInterval) {
        
        //
    }
}
