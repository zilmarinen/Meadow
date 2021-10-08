//
//  MapDecodingOperation.swift
//
//  Created by Zack Brown on 01/10/2021.
//

import Foundation
import PeakOperation

public class MapDecodingOperation: ConcurrentOperation, ConsumesResult, ProducesResult {
 
    public var input: Result<Data, Error> = Result { throw ResultError.noResult }
    public var output: Result<Map, Error> = Result { throw ResultError.noResult }
    
    public override func execute() {
        
        do {
            
            let data = try input.get()
            
            let map = try JSONDecoder().decode(Map.self, from: data)
            
            output = .success(map)
        }
        catch {
            
            output = .failure(error)
        }
        
        finish()
    }
}
