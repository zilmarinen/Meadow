//
//  AreaNodeEdgeWindowType.swift
//  Meadow
//
//  Created by Zack Brown on 27/03/2019.
//  Copyright © 2019 Script Orchard. All rights reserved.
//

public enum AreaNodeEdgeWindowType: Int, Codable {
    
    case plain
    
    public static var allCases: [AreaNodeEdgeWindowType] {
        
        return [.plain
        ]
    }
    
    public var name: String {
        
        switch self {
            
        case .plain: return "Plain"
        }
    }
}

extension AreaNodeEdgeWindowType {
    
    public var meshBuilder: AreaNodeEdgeWindowMesh {
        
        switch self {
            
        case .plain: return PlainAreaNodeEdgeWindowMesh()
            
        default: return PlainAreaNodeEdgeWindowMesh()
        }
    }
}
