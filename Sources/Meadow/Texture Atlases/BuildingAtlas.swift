//
//  BuildingAtlas.swift
//
//  Created by Zack Brown on 09/10/2021.
//

import Foundation

public struct BuildingAtlas {
    
    public let buildings: [BuildingArchitecture: Texture]
    
    init(season: Season) throws {
     
        do {
            
            var buildings: [BuildingArchitecture : Texture] = [:]
            
            for architecture in BuildingArchitecture.allCases {
                
                let image = try MDWImage.asset(named: "building_\(architecture.id)", in: .module)
                
                buildings[architecture] = Texture(key: "architecture", image: image)
            }
            
            self.buildings = buildings
        }
        catch {
            
            throw error
        }
    }
}

extension BuildingAtlas {
    
    func texture(for architecture: BuildingArchitecture) -> Texture? { buildings[architecture] }
}
