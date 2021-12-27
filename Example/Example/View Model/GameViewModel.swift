//
//  GameViewModel.swift
//
//  Created by Zack Brown on 10/10/2021.
//

import Foundation
import Meadow
import SwiftUI

class GameViewModel: ObservableObject {
    
    enum ViewState {
        
        case idle
        case loading(progress: Progress)
        case rendering(scene: MDWScene)
    }
    
    lazy var operationQueue: OperationQueue = {
                
        let queue = OperationQueue()
        
        queue.maxConcurrentOperationCount = 1
        
        return queue
    }()
    
    @Published private(set) var state: ViewState
    
    init() {
        
        state = .idle
        
        let sceneOperation = SceneLoadingOperation(identifier: "island")
        
        let progress = sceneOperation.enqueueWithProgress(on: operationQueue) { result in
            
            switch result {
                
            case .failure(let error): fatalError("Error: \(error)")
            case .success(let scene):
                
                DispatchQueue.main.async { [weak self] in
                    
                    guard let self = self else { return }
                    
                    self.state = .rendering(scene: scene)
                }
            }
        }
        
        state = .loading(progress: progress)
    }
}
