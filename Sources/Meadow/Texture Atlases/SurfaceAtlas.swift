//
//  SurfaceAtlas.swift
//
//  Created by Zack Brown on 09/10/2021.
//

import Foundation

public struct SurfaceAtlas {
    
    public let overlay: Texture
    public let materials: [Texture]
    
    init(season: Season) throws {
     
        do {
            
            var materials: [Texture] = []
            
            for material in SurfaceMaterial.allCases {
                
                let image = try MDWImage.asset(named: "surface_\(material.id)", in: .module)
                
                materials.append(Texture(key: material.id, image: image))
            }
            
            let tileset = try MDWImage.asset(named: "surface_\(season.id)_tileset", in: .module)
            
            overlay = Texture(key: "overlay", image: tileset)
            self.materials = materials
        }
        catch {
            
            throw error
        }
    }
}
