//
//  AppViewModel.swift
//
//  Created by Zack Brown on 09/09/2021.
//

import Foundation
import Meadow

extension AppController {
    
    enum ViewState: State {
        
        case splash(SplashController)
        case game(GameController)
        
        func shouldTransition(to newState: ViewState) -> Should<ViewState> {
            
            return .continue
        }
    }
    
    class AppViewModel: ViewModel<ViewState> {
        
        func loadGame() {
            
            DispatchQueue.main.async { [weak self] in
                
                guard let self = self else { return }
                
                switch self.state {
                    
                case .splash(let controller):
                    
                    guard let parent = controller.parent else { fatalError("Invalid view hierarchy") }
                 
                    let controller = GameController(parent: parent, hero: Hero())
                    
                    self.state = .game(controller)
                    
                default: break
                }
            }
        }
    }
}
