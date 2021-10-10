//
//  WallAtlas.swift
//
//  Created by Zack Brown on 09/10/2021.
//

import Foundation

public struct WallAtlas {
    
    public let materials: [WallMaterial: Texture]
    
    init(season: Season) throws {
     
        do {
            
            var materials: [WallMaterial : Texture] = [:]
            
            for material in WallMaterial.allCases {
                
                let image = try MDWImage.asset(named: "wall_\(material.id)", in: .module)
                
                materials[material] = Texture(key: "material", image: image)
            }
            
            self.materials = materials
        }
        catch {
            
            throw error
        }
    }
}

extension WallAtlas {
    
    func texture(for material: WallMaterial) -> Texture? { materials[material] }
}

