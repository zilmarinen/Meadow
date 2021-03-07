//
//  SplashScreenCoordinator.swift
//  Meadow Example iOS
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

class SplashScreenCoordinator: Coordinator<Scene> {
    
    var completion: (() -> Void)?
    
    let timer: Timer
    
    init(controller: Scene, duration: TimeInterval) {
        
        self.timer = Timer(duration: duration)
        
        super.init(controller: controller)
    }
    
    required public init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    override func start(with option: StartOption?) {
        
        guard let view = option as? SceneView else { fatalError("Invalid start option") }
        
        controller.delegate = self
        controller.camera.floor.drawGrid = false
        
        view.scene = controller
        
        print("start")
    }
    
    override func stop(then completion: CoordinatorCompletionBlock?) {
        
        controller.delegate = nil
        
        super.stop(then: completion)
    }
}

extension SplashScreenCoordinator: SceneDelegate {
    
    func update(delta: TimeInterval, time: TimeInterval) {
        
        guard timer.integrate(delta: delta) else { return }
        
        DispatchQueue.main.async { [weak self] in
            
            guard let self = self else { return }
        
            self.completion?()
        }
    }
}
