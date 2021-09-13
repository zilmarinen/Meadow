//
//  SplashController.swift
//
//  Created by Zack Brown on 26/08/2021.
//

import Foundation
import Meadow
import SwiftUI

class SplashController: ObservableObject, Updatable {
    
    weak var parent: AppController?
    
    lazy var viewModel: SplashViewModel = { return SplashViewModel(controller: self) }()
    
    init(parent: AppController) {
        
        self.parent = parent
    }
}

extension SplashController {
    
    func update(delta: TimeInterval, time: TimeInterval) {
        
        switch viewModel.state {
            
        case .application(let timer):
            
            guard timer.integrate(delta: delta) else { break }
            
            viewModel.complete()
            
        case .developer(let timer):
            
            guard timer.integrate(delta: delta) else { break }
            
            viewModel.show(applicationSplash: timer.duration)
        }
    }
}
