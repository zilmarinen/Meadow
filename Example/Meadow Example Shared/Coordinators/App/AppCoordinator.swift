//
//  AppCoordinator.swift
//  Meadow Example iOS
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

class AppCoordinator: Coordinator<GameViewController> {
    
    lazy var developerSplashCoordinator: SplashScreenCoordinator = {
        
        guard let scene = try? Scene.named(name: "developer_splash") else { fatalError("Unable to load developer splash scene") }
       
        let coordinator = SplashScreenCoordinator(controller: scene, duration: 3.5)
        
        coordinator.parent = self
        coordinator.completion = { [weak self] in
            
            guard let self = self else { return }
            
            self.stateMachine.state = .applicationSplash
        }
        
        return coordinator
    }()
    
    lazy var applicationSplashCoordinator: SplashScreenCoordinator = {
        
        guard let scene = try? Scene.named(name: "application_splash") else { fatalError("Unable to load application splash scene") }
        
        let coordinator = SplashScreenCoordinator(controller: scene, duration: 3.5)
        
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
        sceneView.delegate = self
        sceneView.isPlaying = true
        
        stateMachine.subscribe(stateDidChange(from:to:))
    }
}

extension AppCoordinator {
    
    func stateDidChange(from previousState: ApplicationState?, to currentState: ApplicationState) {
     
        DispatchQueue.main.async { [weak self] in
            
            guard let self = self else { return }
            
            guard let view = self.controller.view as? SceneView else { fatalError("Invalid view setup") }
            
            self.stopChildren()
            
            switch currentState {
            
            case .developerSplash:
                
                print("stateDidChange: developer")
                
                self.start(child: self.developerSplashCoordinator, with: view)
                
            case .applicationSplash:
                
                print("stateDidChange: application")
                
                //self.start(child: self.applicationSplashCoordinator, with: view)
                
            case .mainMenu:
                
                print("stateDidChange: mainMenu")
                
                view.scene = nil
            }
        }
    }
}

extension AppCoordinator: SCNSceneRendererDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        
        switch stateMachine.state {
        
        case .developerSplash:
            
            self.developerSplashCoordinator.controller.renderer(renderer, updateAtTime: time)
            
        case .applicationSplash:
            
            self.applicationSplashCoordinator.controller.renderer(renderer, updateAtTime: time)
            
        case .mainMenu:
            
            print("renderer: updateAtTime: \(time)")
        }
    }
}
