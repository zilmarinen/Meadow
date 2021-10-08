//
//  PropLoadingOperation.swift
//
//  Created by Zack Brown on 29/09/2021.
//

import Foundation
import PeakOperation

public class PropLoadingOperation: ConcurrentOperation, ConsumesResult, ProducesResult {
    
    public var input: Result<([Map], TextureAtlas), Error> = Result { throw ResultError.noResult }
    public var output: Result<([Map], TextureAtlas, Props), Error> = Result { throw ResultError.noResult }
    
    private let props: Props?
    
    public init(props: Props? = nil) {
        
        self.props = props
        
        super.init()
    }
    
    public override func execute() {
        
        do {
            
            let (maps, atlas) = try input.get()
            
            let result = Props()
            
            let bridges = Array(Set(maps.flatMap { $0.bridges.props }))
            let buildings = Array(Set(maps.flatMap { $0.buildings.props }))
            let foliage = Array(Set(maps.flatMap { $0.foliage.props }))
            let stairs = Array(Set(maps.flatMap { $0.stairs.props }))
            let walls = Array(Set(maps.flatMap { $0.walls.props }))
            
            for prop in bridges + buildings + foliage + stairs + walls {
                
                if let model = props?.model(prop: prop) {
                    
                    result.cache(prop: prop, model: model)
                    
                    continue
                }
                
                let model = try prop.load()
                
                result.cache(prop: prop, model: model)
            }
            
            output = .success((maps, atlas, result))
        }
        catch {
            
            output = .failure(error)
        }
        
        finish()
    }
}
