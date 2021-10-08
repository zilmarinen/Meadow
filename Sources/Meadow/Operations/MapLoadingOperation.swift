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
