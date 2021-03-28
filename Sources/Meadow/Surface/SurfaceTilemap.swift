//
//  SurfaceTilemap.swift
//
//  Created by Zack Brown on 26/11/2020.
//

public struct SurfaceTilemap {
    
    public let edgeset: SurfaceEdgeset
    public let tileset: SurfaceTileset
    
    public init?() throws {
        
        guard let edgeset = try SurfaceEdgeset(),
              let tileset = try SurfaceTileset() else { return nil }
        
        self.edgeset = edgeset
        self.tileset = tileset
    }
}
