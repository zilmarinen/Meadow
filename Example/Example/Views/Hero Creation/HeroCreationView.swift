//
//  HeroCreationView.swift
//
//  Created by Zack Brown on 13/09/2021.
//

import Meadow
import SwiftUI

struct HeroCreationView: View {
    
    @ObservedObject var controller: HeroCreationController
    
    @ObservedObject var stateMachine: StateMachine<HeroCreationController.ViewState>
    
    init(controller: HeroCreationController) {
        
        self.controller = controller
        self.stateMachine = controller.viewModel.stateMachine
    }
    
    var body: some View {
        
        switch stateMachine._state {
            
        case .details:
            
            VStack {
            
                TextField("Name", text: $controller.viewModel.stub.name)
                .disableAutocorrection(true)
                .frame(width: 250)
                .background(Color.gray)
                .cornerRadius(3.5)
            
                Button("Done") {
                    
                    controller.viewModel.create()
                }
                .foregroundColor(.black)
            }
            
            
        default: EmptyView()
        }
    }
}
