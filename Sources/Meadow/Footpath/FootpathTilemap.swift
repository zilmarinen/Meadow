//
//  FootpathTilemap.swift
//
//  Created by Zack Brown on 25/03/2021.
//

public struct FootpathTilemap {
    
    public let tileset: FootpathTileset
    
    public init?() throws {
        
        guard let tileset = try FootpathTileset() else { return nil }
        
        self.tileset = tileset
    }
}
