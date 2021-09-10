//
//  ExampleView.swift
//
//  Created by Zack Brown on 10/09/2021.
//

import Foundation
import SwiftUI

struct ExampleView: View {
    
    @ObservedObject var model: AppController.AppViewModel
    
    var body: some View {
        
        switch model.viewState {
            
        case .splash(let controller): SplashView(model: controller.viewModel)
        case .game(let controller): GameView(model: controller.viewModel)
        default: EmptyView()
        }
    }
}
