//
//  BridgeAtlas.swift
//
//  Created by Zack Brown on 09/10/2021.
//

import Foundation

public struct BridgeAtlas {
    
    public let materials: [BridgeMaterial: Texture]
    
    init(season: Season) throws {
     
        do {
            
            var materials: [BridgeMaterial : Texture] = [:]
            
            for material in BridgeMaterial.allCases {
                
                let image = try MDWImage.asset(named: "bridge_\(material.id)", in: .module)
                
                materials[material] = Texture(key: "material", image: image)
            }
            
            self.materials = materials
        }
        catch {
            
            throw error
        }
    }
}

extension BridgeAtlas {
    
    func texture(for material: BridgeMaterial) -> Texture? { materials[material] }
}

