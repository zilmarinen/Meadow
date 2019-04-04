//
//  AreaNodeEdgeMaterial.swift
//  Meadow
//
//  Created by Zack Brown on 22/03/2019.
//  Copyright © 2019 Script Orchard. All rights reserved.
//

public enum AreaNodeEdgeMaterial: Int, Codable {
    
    case breezeBlocks
    case brickwork
    case concrete
    case plasterboard
    
    public static var allCases: [AreaNodeEdgeMaterial] {
        
        return [.breezeBlocks,
                .brickwork,
                .concrete,
                .plasterboard
        ]
    }
    
    public var name: String {
        
        switch self {
            
        case .breezeBlocks: return "Breeze Blocks"
        case .brickwork: return "Brickwork"
        case .concrete: return "Concrete"
        case .plasterboard: return "Plasterboard"
        }
    }
}

extension AreaNodeEdgeMaterial {
    
    public var meshBuilder: AreaNodeEdgeMesh {
        
        switch self {
        
        case .breezeBlocks: return PlasterboardAreaNodeEdgeMesh()
            
        default: return PlasterboardAreaNodeEdgeMesh()
        }
    }
}
