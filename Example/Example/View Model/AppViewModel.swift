//
//  AppViewModel.swift
//
//  Created by Zack Brown on 09/09/2021.
//

import Foundation
import Meadow
import SceneKit

extension AppController {
    
    enum ViewState: State {
        
        case splash(SplashController)
        case heroCreation(HeroCreationController)
        case heroSelection(HeroSelectionController)
        case game(GameController)
        
        func shouldTransition(to newState: ViewState) -> Should<ViewState> {
            
            return .continue
        }
    }
    
    class AppViewModel: StateObserver<ViewState> {
        
        weak var controller: AppController?
        
        required init(controller: AppController) {
            
            self.controller = controller
            
            super.init(initialState: .splash(SplashController(parent: controller)))
        }
        
        lazy var scene: MDWScene = {
            
            let s = MDWScene()
            
            let d = MTLCreateSystemDefaultDevice()
            
            s.library = try? d?.makeDefaultLibrary(bundle: Map.bundle)
            
            return s
        }()
        
        func showHeroCreation() {
            
            DispatchQueue.main.async { [weak self] in
                
                guard let self = self else { return }
                
                switch self.state {
                    
                case .heroSelection:
                    
                    guard let parent = self.controller else { fatalError("Invalid model hierarchy") }
                    
                    let controller = HeroCreationController(parent: parent)
                    
                    self.state = .heroCreation(controller)
                    
                default: break
                }
            }
        }
        
        func showHeroSelection() {
            
            DispatchQueue.main.async { [weak self] in
                
                guard let self = self else { return }
                
                switch self.state {
                    
                case .splash,
                        .heroCreation:
                    
                    guard let parent = self.controller else { fatalError("Invalid model hierarchy") }
                    
                    let controller = HeroSelectionController(parent: parent)
                    
                    self.state = .heroSelection(controller)
                    
                default: break
                }
            }
        }
        
        func load(hero: Hero) {
            
            DispatchQueue.main.async { [weak self] in
                
                guard let self = self else { return }
                
                switch self.state {
                    
                case .heroSelection:
                    
                    guard let parent = self.controller else { fatalError("Invalid model hierarchy") }
                 
                    let controller = GameController(parent: parent, hero: hero)
                    
                    self.state = .game(controller)
                    
                default: break
                }
            }
        }
    }
}
