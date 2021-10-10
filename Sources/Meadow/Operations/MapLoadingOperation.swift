//
//  MapLoadingOperation.swift
//
//  Created by Zack Brown on 27/09/2021.
//

import Foundation
import PeakOperation

#if os(macOS)

    import AppKit

#else

    import UIKit

#endif

class MapLoadingOperation: ConcurrentOperation, ProducesResult {
    
    public var output: Result<Map, Error> = Result { throw ResultError.noResult }
    
    private let identifier: String
    
    init(identifier: String) {
        
        self.identifier = identifier
        
        super.init()
    }
    
    override func execute() {
        
        do {
            
            let asset = try NSDataAsset.asset(named: identifier, in: .main)
            
            let map = try JSONDecoder().decode(Map.self, from: asset.data)
            
            output = .success(map)
            
        }
        catch {
        
            output = .failure(error)
        }
        
        finish()
    }
}

public class MapLoadingOperation2: ConcurrentOperation, ConsumesResult, ProducesResult {
    
    public var input: Result<TextureAtlas, Error> = Result { throw ResultError.noResult }
    public var output: Result<([Map], TextureAtlas), Error> = Result { throw ResultError.noResult }
    
    private let identifier: String
    
    public init(identifier: String) {
        
        self.identifier = identifier
        
        super.init()
    }
    
    public override func execute() {
        
        do {
            
            let atlas = try input.get()
            
            let asset = try NSDataAsset.asset(named: identifier, in: .main)
            
            let map = try JSONDecoder().decode(Map.self, from: asset.data)
            
            output = .success(([map], atlas))
            
        }
        catch {
        
            output = .failure(error)
        }
        
        finish()
    }
}
