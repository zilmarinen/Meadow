//
//  GameView.swift
//
//  Created by Zack Brown on 26/08/2021.
//

import SwiftUI
import Meadow

struct GameView: View {
    
    var controller: GameController
    
    @ObservedObject var stateMachine: StateMachine<GameController.ViewState>
    
    init(controller: GameController) {
        
        self.controller = controller
        self.stateMachine = controller.viewModel.stateMachine
    }
    
    var body: some View {
        
        switch stateMachine._state {
            
        case .initialising: EmptyView()
        case .loading: Text("Loading").foregroundColor(.black)
        case .scene: Text("Scene").foregroundColor(.black)
        }
    }
}
