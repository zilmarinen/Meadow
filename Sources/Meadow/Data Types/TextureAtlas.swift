//
//  TextureAtlas.swift
//
//  Created by Zack Brown on 27/09/2021.
//

import Foundation

public struct TextureAtlas {
    
    public struct Surface {
        
        public let overlay: Texture
        public let materials: [Texture]
    }
    
    public let season: Season
    public let footpath: Texture
    public let surface: Surface
    
    init(season: Season) throws {
        
        do {
            
            let footpathTileset = try MDWImage.asset(named: "footpath_\(season.id)_tileset", in: .module)
            let surfaceTileset = try MDWImage.asset(named: "surface_\(season.id)_tileset", in: .module)
            
            var surfaceMaterials: [Texture] = []
            
            for material in SurfaceMaterial.allCases {
                
                let image = try MDWImage.asset(named: "surface_\(material.id)", in: .module)
                
                surfaceMaterials.append(Texture(key: material.id, image: image))
            }
            
            self.season = season
            self.footpath = Texture(key: "overlay", image: footpathTileset)
            self.surface = Surface(overlay: Texture(key: "overlay", image: surfaceTileset), materials: surfaceMaterials)
        }
        catch {
            
            throw(error)
        }
    }
}
