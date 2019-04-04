//
//  AreaNodeEdgeDoorType.swift
//  Meadow
//
//  Created by Zack Brown on 27/03/2019.
//  Copyright © 2019 Script Orchard. All rights reserved.
//

public enum AreaNodeEdgeDoorType: Int, Codable {
    
    case plain
    
    public static var allCases: [AreaNodeEdgeDoorType] {
        
        return [.plain
        ]
    }
    
    public var name: String {
        
        switch self {
            
        case .plain: return "Plain"
        }
    }
}

extension AreaNodeEdgeDoorType {
    
    public var meshBuilder: AreaNodeEdgeDoorMesh {
        
        switch self {
            
        case .plain: return PlainAreaNodeEdgeDoorMesh()
            
        default: return PlainAreaNodeEdgeDoorMesh()
        }
    }
}
