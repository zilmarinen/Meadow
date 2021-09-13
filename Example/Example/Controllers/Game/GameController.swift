//
//  GameController.swift
//
//  Created by Zack Brown on 26/08/2021.
//

import Foundation
import Meadow
import SwiftUI

class GameController: ObservableObject, Updatable {
    
    weak private(set) var parent: AppController?
    
    lazy var viewModel: GameViewModel = { return GameViewModel(controller: self, hero: hero) }()
    
    let hero: Hero
    
    init(parent: AppController, hero: Hero) {
        
        self.parent = parent
        self.hero = hero
    }
}

extension GameController {
    
    func update(delta: TimeInterval, time: TimeInterval) {
        
        //
    }
}
