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
        
        let atlasOperation = TextureAtlasOperation(season: .spring)
        let mapOperation = MapLoadingOperation2(identifier: "island")
        let propOperation = PropLoadingOperation()
        
        let progress = atlasOperation.passesResult(to: mapOperation).passesResult(to: propOperation).enqueueWithProgress(on: operationQueue) { result in
            
            switch result {
                
            case .failure(let error): fatalError("Error: \(error)")
            case .success(let output):
                
                DispatchQueue.main.async { [weak self] in
                    
                    guard let self = self else { return }
                    
                    let (maps, atlas, props) = output
                                            
                    guard let map = maps.first else { fatalError("Invalid map") }
                    
                    let scene = MDWScene(map: map, atlas: atlas, props: props)
                    
                    self.state = .rendering(scene: scene)
                    
                    //TODO: catch device library errrors
                    guard let device = MTLCreateSystemDefaultDevice() else { return }
                    
                    scene.library = try? device.makeDefaultLibrary(bundle: Map.bundle)
                }
            }
        }
        
        state = .loading(progress: progress)
    }
}
