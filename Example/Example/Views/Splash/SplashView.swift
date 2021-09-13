//
//  SplashView.swift
//
//  Created by Zack Brown on 23/08/2021.
//

import SwiftUI
import Meadow

struct SplashView: View {
    
    var controller: SplashController
    
    @ObservedObject var stateMachine: StateMachine<SplashController.ViewState>
    
    init(controller: SplashController) {
        
        self.controller = controller
        self.stateMachine = controller.viewModel.stateMachine
    }
    
    var body: some View {
        
        switch stateMachine._state {
            
        case .application: Text("Application").foregroundColor(.black)
        case .developer: Text("Developer").foregroundColor(.black)
        }
    }
}
