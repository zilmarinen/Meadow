//
//  FoliageAtlas.swift
//
//  Created by Zack Brown on 09/10/2021.
//

import Foundation

public struct FoliageAtlas {
    
    public let trees: [TreeSpecies: Texture]
    
    init(season: Season) throws {
     
        do {
            
            var trees: [TreeSpecies : Texture] = [:]
            
            for species in TreeSpecies.allCases {
                
                let image = try MDWImage.asset(named: "foliage_\(species.id)", in: .module)
                
                trees[species] = Texture(key: "foliage", image: image)
            }
            
            self.trees = trees
        }
        catch {
            
            throw error
        }
    }
}

extension FoliageAtlas {
    
    func texture(for foliage: FoliageType) -> Texture? {
        
        switch foliage {
            
        case .bush(let species): return nil
        case .rock(let rockType): return nil
        case .tree(let species): return trees[species]
        }
    }
}
