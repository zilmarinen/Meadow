//
//  FootpathAtlas.swift
//
//  Created by Zack Brown on 09/10/2021.
//

import Foundation

public struct FootpathAtlas {
    
    public let overlay: Texture
    
    init(season: Season) throws {
     
        do {
            
            let tileset = try MDWImage.asset(named: "footpath_\(season.id)_tileset", in: .module)
            
            overlay = Texture(key: "overlay", image: tileset)
        }
        catch {
            
            throw error
        }
    }
}
