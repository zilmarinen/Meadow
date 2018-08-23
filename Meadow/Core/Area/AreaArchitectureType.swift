//
//  AreaArchitectureType.swift
//  Meadow-iOS
//
//  Created by Zack Brown on 21/08/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

public enum AreaArchitectureType: Int, Codable {
    
    case american
    case spanish
    case tudor
    
    public static var allCases: [AreaArchitectureType] {
        
        return [ .american,
                 .spanish,
                 .tudor
        ]
    }
    
    public var name: String {
        
        switch self {
            
        case .american: return "American"
        case .spanish: return "Spanish"
        case .tudor: return "Tudor"
        }
    }
}

extension AreaArchitectureType {
    
    var meshProvider: AreaArchitectureMeshProvider {
        
        switch self {
            
        case .tudor: return TudorAreaArchitectureMeshProvider()
        default: return TudorAreaArchitectureMeshProvider()
        }
    }
}
