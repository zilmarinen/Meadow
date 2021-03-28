//
//  Tilemaps.swift
//
//  Created by Zack Brown on 01/12/2020.
//

import Foundation

public struct Tilemaps {
    
    public let surface: SurfaceTilemap
    
    init?() throws {
        
        guard let surface = try SurfaceTilemap() else { return nil }
        
        self.surface = surface
    }
}
