//
//  FoliageType.swift
//  
//  Created by Zack Brown on 15/03/2021.
//

import Foundation

public enum FoliageType: CaseIterable, Codable, Hashable, Identifiable {
    
    public static var allCases: [FoliageType] = [.bush(species: .honeysuckle),
                                                 .rock(rockType: .causeway),
                                                 .tree(species: .spruce)]
    
    case bush(species: BushSpecies)
    case rock(rockType: RockType)
    case tree(species: TreeSpecies)
    
    public var id: String {
        
        switch self {
        
        case .bush: return "bush"
        case .rock: return "rock"
        case .tree: return "tree"
        }
    }
    
    var propIdentifier: String {
        
        switch self {
        
        case .bush(let species): return "\(species.id)_bush"
        case .rock(let rockType): return "\(rockType.id)_rock"
        case .tree(let species): return "\(species.id)_tree"
        }
    }
}
