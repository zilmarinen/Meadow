//
//  AppCoordinator.swift
//
//  Created by Zack Brown on 06/01/2021.
//

import Meadow
import SceneKit

extension AppCoordinator {
    
    enum ApplicationState: State {
        
        case applicationSplash
        case developerSplash
        case mainMenu
        
        func shouldTransition(to newState: ApplicationState) -> Should<ApplicationState> {
            
            return .continue
        }
    }
    
    class ApplicationStateMachine: StateObserver<ApplicationState> {
        
    }
}

class AppCoordinator: ViewCoordinator {
    
    lazy var developerSplashCoordinator: DeveloperSplashScreenCoordinator = {
        
        let coordinator = DeveloperSplashScreenCoordinator(controller: controller, duration: 3.5)
        
        coordinator.parent = self
        coordinator.completion = { [weak self] in
            
            guard let self = self else { return }
            
            self.stateMachine.state = .applicationSplash
        }
        
        return coordinator
    }()
    
    lazy var applicationSplashCoordinator: ApplicationSplashScreenCoordinator = {
        
        let coordinator = ApplicationSplashScreenCoordinator(controller: controller, duration: 3.5)
        
        coordinator.parent = self
        coordinator.completion = { [weak self] in
            
            guard let self = self else { return }
            
            self.stateMachine.state = .mainMenu
        }
        
        return coordinator
    }()
    
    lazy var stateMachine: ApplicationStateMachine = {
       
        return ApplicationStateMachine(initialState: .developerSplash)
    }()
    
    override func start(with option: StartOption?) {
        
        super.start(with: option)
        
        guard let sceneView = controller.view as? SceneView else { fatalError("Invalid view hierarchy") }
        
        guard let device = sceneView.device else { fatalError("Invalid device library") }
        
        sceneView.library = try? device.makeDefaultLibrary(bundle: Meadow.bundle)
        
        stateMachine.subscribe(stateDidChange(from:to:))
    }
    
    override func start(child coordinator: Coordinatable, with option: StartOption?) {
        
        guard let coordinator = coordinator as? ViewCoordinator else { return }
        
        coordinator.controller = controller
        
        super.start(child: coordinator, with: option)
    }
}

extension AppCoordinator {
    
    func stateDidChange(from previousState: ApplicationState?, to currentState: ApplicationState) {
     
        DispatchQueue.main.async { [weak self] in
            
            guard let self = self else { return }
            
            self.stopChildren()
            
            switch currentState {
            
            case .developerSplash:
                
                print("stateDidChange: developer")
                
                self.start(child: self.developerSplashCoordinator, with: nil)
                
            case .applicationSplash:
                
                print("stateDidChange: application")
                
                //self.start(child: self.applicationSplashCoordinator, with: view)
                
            case .mainMenu:
                
                print("stateDidChange: mainMenu")
                
                //view.scene = nil
            }
        }
    }
}
