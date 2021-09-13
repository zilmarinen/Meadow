//
//  GameViewModel.swift
//
//  Created by Zack Brown on 10/09/2021.
//

import Foundation
import Meadow

extension GameController {
    
    enum ViewState: State {
        
        case initialising
        case loading(Map)
        case scene(SceneController)
        
        func shouldTransition(to newState: ViewState) -> Should<ViewState> {
            
            return .continue
        }
    }
    
    class GameViewModel: StateObserver<ViewState> {
        
        weak var controller: GameController?
        
        let hero: Hero
        
        required init(controller: GameController, hero: Hero) {
            
            self.controller = controller
            self.hero = hero
            
            super.init(initialState: .initialising)
        }
        
        override func stateDidChange(from previousState: ViewState?, to currentState: ViewState) {
            
            switch currentState {
                
            case .initialising:
                
                print("Loading Hero: \(hero)")
                
                guard let map = try? Map.map(named: "island") else { fatalError("Unable to load map") }
                
                state = .loading(map)
                
            case .loading(let map):
                
                guard let parent = controller?.parent else { fatalError("Invalid model hierarchy") }
                
                print("Loading Map: \(map.name ?? "")")
                
                parent.viewModel.scene.load(map: map)
                
                let controller = SceneController(parent: parent)
                
                state = .scene(controller)
                
            default: break
            }
        }
    }
}
