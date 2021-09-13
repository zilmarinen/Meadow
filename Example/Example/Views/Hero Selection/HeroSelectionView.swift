//
//  HeroSelectionView.swift
//
//  Created by Zack Brown on 13/09/2021.
//

import Meadow
import SwiftUI

struct HeroSelectionView: View {
    
    var controller: HeroSelectionController
    
    @ObservedObject var stateMachine: StateMachine<HeroSelectionController.ViewState>
    
    @Environment(\.managedObjectContext) var context
    
    @FetchRequest(entity: Hero.entity(),
                  sortDescriptors: [NSSortDescriptor(keyPath: \Hero.dateCreated, ascending: true)]) var heros: FetchedResults<Hero>
    
    init(controller: HeroSelectionController) {
        
        self.controller = controller
        self.stateMachine = controller.viewModel.stateMachine
    }
        
    var body: some View {
        
        HStack {
            
            ForEach(0..<3, id: \.self) {
                
                let hero = $0 < heros.count ? heros[$0] : nil
                
                HeroSelectionCardView(hero: hero) {
                    
                    controller.parent?.viewModel.showHeroCreation()
                    
                } select: { hero in
                    
                    controller.parent?.viewModel.load(hero: hero)
                    
                } delete: { hero in
                    
                    controller.viewModel.delete(hero: hero)
                }
            }
        }
    }
}
