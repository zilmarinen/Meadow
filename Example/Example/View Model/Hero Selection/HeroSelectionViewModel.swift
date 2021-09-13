//
//  HeroSelectionViewModel.swift
//
//  Created by Zack Brown on 13/09/2021.
//

import Foundation
import Meadow

extension HeroSelectionController {
    
    enum ViewState: State {
        
        case selection
        
        func shouldTransition(to newState: ViewState) -> Should<ViewState> {
            
            return .continue
        }
    }
    
    class HeroSelectionViewModel: StateObserver<ViewState> {
        
        weak var controller: HeroSelectionController?
        
        required init(controller: HeroSelectionController) {
            
            self.controller = controller
            
            super.init(initialState: .selection)
        }
        
        func delete(hero: Hero) {
            
            PersistenceController.shared.container.viewContext.delete(hero)
            
            PersistenceController.shared.save()
        }
    }
}
