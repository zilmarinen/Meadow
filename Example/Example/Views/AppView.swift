//
//  AppView.swift
//
//  Created by Zack Brown on 18/08/2021.
//

import CoreGraphics
import Meadow
import SceneKit
import SwiftUI

struct AppView: View {
    
    var controller: AppController
    
    @ObservedObject var stateMachine: StateMachine<AppController.ViewState>
    
    init(controller: AppController) {
        
        self.controller = controller
        self.stateMachine = controller.viewModel.stateMachine
    }
    
    var body: some View {
        
        ZStack {
            
            SceneView(scene: controller.viewModel.scene,
                      pointOfView: controller.viewModel.scene.camera.jig,
                      options: [.rendersContinuously],
                      delegate: controller)
            
            switch stateMachine._state {
                
            case .splash(let controller): SplashView(controller: controller)
            case .heroCreation(let controller): HeroCreationView(controller: controller)
            case .heroSelection(let controller): HeroSelectionView(controller: controller)
            case .game(let controller): GameView(controller: controller)
            }
        }
    }
}
