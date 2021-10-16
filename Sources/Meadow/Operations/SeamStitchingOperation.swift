//
//  SeamStitchingOperation.swift
//
//  Created by Zack Brown on 27/09/2021.
//

import Foundation
import PeakOperation

class SeamStitchingOperation: ConcurrentOperation, ConsumesResult, ProducesResult {
    
    public var input: Result<(Map, Props), Error> = Result { throw ResultError.noResult }
    public var output: Result<(Map, Props), Error> = Result { throw ResultError.noResult }
    
    private let seam: SeamTile
    
    init(seam: SeamTile) {
        
        self.seam = seam
        
        super.init()
    }
    
    override func execute() {
        
        do {
            
            let (map, props) = try input.get()
            
            guard let stitch = map.seams.find(seam: seam.segue.identifier) else { throw SeamStitchingError.missingSeam(seam.segue) }
            
            map.offset = ((seam.coordinate + seam.segue.direction.coordinate) - stitch.coordinate)
            
            output = .success((map, props))
        }
        catch {
            
            output = .failure(error)
        }
        
        finish()
    }
}
