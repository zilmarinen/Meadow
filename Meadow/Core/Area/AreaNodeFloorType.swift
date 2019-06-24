//
//  AreaNodeFloorType.swift
//  Meadow
//
//  Created by Zack Brown on 22/03/2019.
//  Copyright © 2019 Script Orchard. All rights reserved.
//

public enum AreaNodeFloorType: Int, Codable {
    
    case plain
    case slotted
    case squares
    case triangles
    
    public static var allCases: [AreaNodeFloorType] {
        
        return [.plain,
                .slotted,
                .squares,
                .triangles
        ]
    }
    
    public var name: String {
        
        switch self {
            
        case .plain: return "Plain"
        case .slotted: return "Slotted"
        case .squares: return "Squares"
        case .triangles: return "Triangles"
        }
    }
}

extension AreaNodeFloorType {
    
    public var meshBuilder: AreaNodeFloorMesh {
        
        switch self {
            
        case .plain: return PlainAreaNodeFloorMesh()
            
        default: return PlainAreaNodeFloorMesh()
        }
    }
}

extension AreaNodeFloorType {
    
    public var movementCost: Int {
        
        return 1
    }
}
