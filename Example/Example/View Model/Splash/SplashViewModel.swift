//
//  SplashViewModel.swift
//
//  Created by Zack Brown on 09/09/2021.
//

import Foundation
import Meadow

extension SplashController {
    
    enum ViewState: State {
        
        case application(Stopwatch)
        case developer(Stopwatch)
        
        func shouldTransition(to newState: ViewState) -> Should<ViewState> {
            
            return .continue
        }
    }
    
    class SplashViewModel: StateObserver<ViewState> {
        
        weak var controller: SplashController?
        
        required init(controller: SplashController) {
            
            self.controller = controller
            
            super.init(initialState: .developer(.init(duration: 1)))
        }
        
        func show(applicationSplash duration: TimeInterval) {
            
            DispatchQueue.main.async { [weak self] in
                
                guard let self = self else { return }
                
                switch self.state {
                    
                case .developer: self.state = .application(Stopwatch(duration: duration))
                default: break
                }
            }
        }
        
        func complete() {
            
            controller?.parent?.viewModel.showHeroSelection()
        }
    }
}
