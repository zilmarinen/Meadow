//
//  SplashViewModel.swift
//
//  Created by Zack Brown on 10/10/2021.
//

import Combine
import SwiftUI

protocol SplashViewModelDelegate: AnyObject {
    
    func splashViewDone()
}

class SplashViewModel: ObservableObject {
    
    enum ViewState {
        
        case application
        case developer
    }
    
    @Published private(set) var state: ViewState = .developer
    
    let timer = Timer.publish(every: 2, on: .main, in: .common).autoconnect()
    
    weak var delegate: SplashViewModelDelegate?
    
    init(delegate: SplashViewModelDelegate) {
        
        self.delegate = delegate
    }
}

extension SplashViewModel {
    
    func toggle() {
        
        switch state {
            
        case .developer: state = .application
        case .application: delegate?.splashViewDone()
        }
    }
}
