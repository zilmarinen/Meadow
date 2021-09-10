//
//  SplashController.swift
//
//  Created by Zack Brown on 26/08/2021.
//

import Foundation
import Meadow
import SwiftUI

open class ViewModel<ViewState: Meadow.State>: StateObserver<ViewState>, ObservableObject {
    
    @Published private(set) public var viewState: ViewState?
    
    open override func stateDidChange(from previousState: ViewState?, to currentState: ViewState) {
        
        print("ViewModel->stateDidChange(\(currentState))")
        
        viewState = currentState
    }
}

class SplashController: NSObject, ObservableObject, Updatable {
    
    weak var parent: AppController?
    
    @ObservedObject var viewModel = SplashViewModel(initialState: .developer(.init(duration: 1)))
    
    init(parent: AppController? = nil) {
        
        self.parent = parent
        
        super.init()
    }
}

extension SplashController {
    
    func update(delta: TimeInterval, time: TimeInterval) {
        
        switch viewModel.state {
            
        case .application(let timer):
            
            guard timer.integrate(delta: delta) else { break }
            
            parent?.viewModel.loadGame()
            
        case .developer(let timer):
            
            guard timer.integrate(delta: delta) else { break }
            
            viewModel.show(applicationSplash: timer.duration)
        }
    }
}
