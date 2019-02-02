//
//  FoliageType.swift
//  Meadow
//
//  Created by Zack Brown on 23/07/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

public enum FoliageType: Int, Codable {
    
    case bush
    case shrub
    case hedge
    case tree
    
    public static var allCases: [FoliageType] {
        
        return [ .bush,
                 .shrub,
                 .hedge,
                 .tree
        ]
    }
    
    public var name: String {
        
        switch self {
            
        case .bush: return "Bush"
        case .shrub: return "Shrub"
        case .hedge: return "Hedge"
        case .tree: return "Tree"
        }
    }
}

extension FoliageType {
    
    var meshProvider: FoliageNodeMeshProvider {
        
        switch self {
            
        case .bush: return HedgeFoliageNodeMeshProvider()
        case .shrub: return HedgeFoliageNodeMeshProvider()
        case .hedge: return HedgeFoliageNodeMeshProvider()
        case .tree: return HedgeFoliageNodeMeshProvider()
        }
    }
}
