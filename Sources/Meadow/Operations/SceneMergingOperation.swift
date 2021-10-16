//
//  SceneMergingOperation.swift
//
//  Created by Zack Brown on 11/10/2021.
//

import Foundation
import PeakOperation

class SceneMergingOperation: ConcurrentOperation, ConsumesResult, ProducesResult {
    
    public var input: Result<([Map], Props), Error> = Result { throw ResultError.noResult }
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
        
        do {
            
            let (maps, props) = try input.get()
            
            let removed = mapCache.filter { !maps.contains($0) }
            
            for seam in removed {
                
                seam.ancestor = nil
                seam.removeFromParentNode()
            }
            
            for prop in map.props {
                
                guard let model = propCache.model(prop: prop) else { throw SceneMergingError.missingProp(prop.identifier) }
                
                props.cache(prop: prop, model: model)
            }
            
            output = .success((maps, props))
        }
        catch {
            
            output = .failure(error)
        }
        
        finish()
    }
}
