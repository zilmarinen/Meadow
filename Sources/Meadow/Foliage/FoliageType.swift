//
//  FoliageType.swift
//  
//  Created by Zack Brown on 15/03/2021.
//

import Foundation

#if os(macOS)

    import AppKit

#else

    import UIKit

#endif

public enum FoliageType: Int, CaseIterable, Codable, Equatable, Identifiable {
    
    case palm
    case pine
    case spruce
    
    public var id: String {
        
        switch self {
        
        case .palm: return "palm_tree"
        case .pine: return "pine_tree"
        case .spruce: return "spruce_tree"
        }
    }
    
    var texture: Texture? {
        
        guard let image = MDWImage.asset(named: "foliage_" + id, in: .module) else { return nil }
        
        return Texture(key: "foliage", image: image)
    }
}
