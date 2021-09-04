//
//  SplashController.swift
//
//  Created by Zack Brown on 26/08/2021.
//

import Foundation
import Meadow

class SplashController: NSObject, ObservableObject, Updatable {
    
    enum State {
        
        case application(Stopwatch)
        case developer(Stopwatch)
    }
    
    weak var parent: AppController?
    
    @Published private(set) var state: State = .developer(.init(duration: 1))
}

extension SplashController {
    
    func update(delta: TimeInterval, time: TimeInterval) {
        
        switch state {
            
        case .application(let timer):
            
            guard timer.integrate(delta: delta) else { break }
            
            parent?.loadGame()
            
        case .developer(let timer):
            
            guard timer.integrate(delta: delta) else { break }
            
            show(applicationSplash: timer.duration)
        }
    }
}

extension SplashController {
    
    func show(applicationSplash duration: TimeInterval) {
        
        DispatchQueue.main.async { [weak self] in
            
            guard let self = self else { return }
            
            self.state = .application(Stopwatch(duration: duration))
        }
    }
}
