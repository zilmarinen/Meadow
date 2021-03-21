//
//  ApplicationSplashScreenCoordinator.swift
//
//  Created by Zack Brown on 08/01/2021.
//

import Foundation
import Meadow
import SceneKit

class Timer {
    
    let duration: TimeInterval
    var elapsed: TimeInterval = 0
    
    init(duration: TimeInterval) {
        
        self.duration = duration
    }
    
    func integrate(delta: TimeInterval) -> Bool {
        
        elapsed += delta
        
        return elapsed >= duration
    }
}

class ApplicationSplashScreenCoordinator: ViewCoordinator {
    
    var completion: (() -> Void)?
    
    let timer: Timer
    
    init(controller: GameViewController, duration: TimeInterval) {
        
        self.timer = Timer(duration: duration)
        
        super.init(controller: controller)
    }
    
    required public init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    override func start(with option: StartOption?) {
        
        super.start(with: option)
        
        print("ApplicationSplashScreenCoordinator -> start")
        
        //
    }
}
