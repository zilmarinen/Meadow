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
    private let cache: [Map]
    
    init(identifier: String, cache: [Map] = []) {
        
        self.identifier = identifier
        self.cache = cache
        
        super.init()
    }
    
    override func execute() {
        
        do {
            
            if let map = cache.first(where: { $0.identifier == identifier }) {
                
                output = .success(map)
                
                return finish()
            }
            
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
