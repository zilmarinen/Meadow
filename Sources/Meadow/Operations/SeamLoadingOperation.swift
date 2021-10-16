//
//  SeamLoadingOperation.swift
//
//  Created by Zack Brown on 27/09/2021.
//

import Foundation
import PeakOperation

class SeamLoadingOperation: ConcurrentOperation, ProducesResult {
    
    public var output: Result<([Map], Props), Error> = Result { throw ResultError.noResult }
    
    private let map: Map
    private let mapCache: [Map]
    private let propCache: Props
    
    init(map: Map, mapCache: [Map], propCache: Props) {
        
        self.map = map
        self.mapCache = mapCache
        self.propCache = propCache
        
        super.init()
    }
    
    override func execute() {
        
        let group = DispatchGroup()
        
        var results: (maps: [Map], props: Props) = ([map], Props())
        var errors: [PortalSegue] = []
        
        for seam in map.seams.tiles {
            
            let mapOperation = MapLoadingOperation(identifier: seam.segue.map, cache: mapCache)
            let propOperation = PropLoadingOperation(cache: propCache)
            let stitchingOperation = SeamStitchingOperation(seam: seam)
            
            group.enter()
            
            mapOperation.passesResult(to: propOperation).passesResult(to: stitchingOperation).enqueue(on: internalQueue) { result in
                
                switch result {
                    
                case .failure: errors.append(seam.segue)
                case .success(let result):
                    
                    let (map, props) = result
                    
                    results.maps.append(map)
                    results.props.merge(cache: props)
                }
                
                group.leave()
            }
        }
        
        group.wait()
        
        output = errors.isEmpty ? .success(results) : .failure(SeamStitchingError.droppedStitches(errors))
        
        finish()
    }
}
