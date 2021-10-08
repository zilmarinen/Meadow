//
//  SurfaceTileType.swift
//
//  Created by Zack Brown on 12/11/2020.
//

public enum SurfaceTileType: Int, CaseIterable, Codable, Identifiable {
    
    case sloped
    case terraced
    
    public var id: String {
        
        switch self {
        
        case .sloped: return "sloped"
        case .terraced: return "terraced"
        }
    }
}
