//
//  AreaTilemap.swift
//
//  Created by Zack Brown on 08/12/2020.
//

struct AreaTilemap {
    
    let edgeset: AreaEdgeset
    let tileset: AreaTileset
    
    init?() throws {
        
        guard let edgeset = try AreaEdgeset(), 
              let tileset = try AreaTileset() else { return nil }
        
        self.edgeset = edgeset
        self.tileset = tileset
    }
}
