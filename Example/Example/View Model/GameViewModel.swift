//
//  GameViewModel.swift
//
//  Created by Zack Brown on 10/09/2021.
//

import Foundation
import Meadow

extension GameController {
    
    enum ViewState: State {
        
        case initialising(Hero)
        case loading(Map)
        case scene(SceneController)
        
        func shouldTransition(to newState: ViewState) -> Should<ViewState> {
            
            return .continue
        }
    }
    
    class GameViewModel: ViewModel<ViewState> {
        
        override func stateDidChange(from previousState: GameController.ViewState?, to currentState: GameController.ViewState) {
            
            switch currentState {
                
            case .initialising(let hero):
                
                print("Loading Hero: \(hero)")
                
                guard let map = try? Map.map(named: "island") else { fatalError("Unable to load map") }
                
                state = .loading(map)
                
            case .loading(let map):
                
                print("Loading Map: \(map.name ?? "")")
                
                
                
            default: break
            }
        }
        
        
    }
}
