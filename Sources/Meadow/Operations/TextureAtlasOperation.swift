//
//  TextureAtlasOperation.swift
//
//  Created by Zack Brown on 27/09/2021.
//

import Foundation
import PeakOperation

public class TextureAtlasOperation: ConcurrentOperation, ProducesResult {
    
    public var output: Result<TextureAtlas, Error> = Result { throw ResultError.noResult }
    
    private let season: Season
    
    public init(season: Season) {
        
        self.season = season
        
        super.init()
    }
    
    public override func execute() {
        
        do {
            
            let tilesets = try TextureAtlas(season: season)
            
            output = .success(tilesets)
        }
        catch {
         
            output = .failure(error)
        }
        
        finish()
    }
}
