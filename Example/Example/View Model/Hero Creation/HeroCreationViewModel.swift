//
//  HeroCreationViewModel.swift
//
//  Created by Zack Brown on 13/09/2021.
//

import Foundation
import Meadow

extension HeroCreationController {
    
    enum ViewState: State {
        
        case details
        
        func shouldTransition(to newState: ViewState) -> Should<ViewState> {
            
            return .continue
        }
    }
    
    class HeroCreationViewModel: StateObserver<ViewState> {
        
        struct HeroStub {
            
            var name = "Yxli"
        }
        
        weak var controller: HeroCreationController?
        
        @Published var stub = HeroStub()
        
        required init(controller: HeroCreationController) {
            
            self.controller = controller
            
            super.init(initialState: .details)
        }
        
        func create() {
                
            let hero = Hero(context: PersistenceController.shared.container.viewContext)
            
            hero.heroID = UUID()
            hero.dateCreated = Date()
            
            hero.name = stub.name
            
            PersistenceController.shared.save()
            
            controller?.parent?.viewModel.showHeroSelection()
        }
    }
}
