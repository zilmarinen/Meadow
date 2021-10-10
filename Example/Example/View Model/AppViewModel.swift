//
//  AppViewModel.swift
//
//  Created by Zack Brown on 09/09/2021.
//

import SwiftUI

class AppViewModel: ObservableObject {
    
    enum ViewState {
        
        case splash
        case menu
        case scene
    }
    
    @Published private(set) var state: ViewState = .splash
}

extension AppViewModel: SplashViewModelDelegate {
    
    func splashViewDone() {
        
        state = .menu
    }
}

extension AppViewModel {
    
    func startNewGame() {
        
        state = .scene
    }
}
