//
//  PropLoadingOperation.swift
//
//  Created by Zack Brown on 29/09/2021.
//

import Foundation
import PeakOperation

public class PropLoadingOperation: ConcurrentOperation, ConsumesResult, ProducesResult {
    
    public var input: Result<Map, Error> = Result { throw ResultError.noResult }
    public var output: Result<(Map, Props), Error> = Result { throw ResultError.noResult }
    
    private let cache: Props?
    
    public init(cache: Props? = nil) {
        
        self.cache = cache
        
        super.init()
    }
    
    public override func execute() {
        
        do {
            
            let map = try input.get()
            
            let props = Props()
            
            for prop in map.props {
                
                if let model = cache?.model(prop: prop) {
                    
                    props.cache(prop: prop, model: model)
                    
                    continue
                }
                
                let model = try prop.load()
                
                props.cache(prop: prop, model: model)
            }
            
            output = .success((map, props))
        }
        catch {
            
            output = .failure(error)
        }
        
        finish()
    }
}
