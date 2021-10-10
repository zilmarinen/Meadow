//
//  AppView.swift
//
//  Created by Zack Brown on 18/08/2021.
//

import SwiftUI

struct AppView: View {
    
    @ObservedObject var model: AppViewModel
    
    var body: some View {
        
        switch model.state {
            
        case .splash: SplashView(model: .init(delegate: model))
        case .menu: MenuView(model: model)
        case .scene: GameView(model: .init())
        }
    }
}
