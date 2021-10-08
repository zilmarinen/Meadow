//
//  SeamLoadingOperation.swift
//
//  Created by Zack Brown on 27/09/2021.
//

import Foundation
import PeakOperation

class SeamLoadingOperation: ConcurrentOperation, ProducesResult {
    
    public var output: Result<[Map], Error> = Result { throw ResultError.noResult }
    
    private let map: Map
    private let maps: [Map]
    
    init(map: Map, maps: [Map]) {
        
        self.map = map
        self.maps = maps
        
        super.init()
    }
    
    override func execute() {
        
        let group = DispatchGroup()
        
        var results: [Map] = [map]
        var errors: [PortalSegue] = []
        
        for seam in map.seams.tiles {
            
            let map = maps.first { $0.identifier == seam.segue.map }
            
            if let map = map {
                
                results.append(map)
                
                continue
            }
            
            let loadingOperation = MapLoadingOperation(identifier: seam.segue.map)
            let stitchingOperation = SeamStitchingOperation(seam: seam)
            
            group.enter()
            
            loadingOperation.passesResult(to: stitchingOperation).enqueue(on: internalQueue) { result in
                
                switch result {
                    
                case .failure:
                    
                    errors.append(seam.segue)
                    
                case .success(let map):
                    
                    results.append(map)
                }
                
                group.leave()
            }
        }
        
        group.wait()
        
        output = errors.isEmpty ? .success(results) : .failure(SeamStitchingError.droppedStitches(errors))
        
        finish()
    }
}
