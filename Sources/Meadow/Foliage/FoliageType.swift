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

public enum FoliageType: Int, CaseIterable, Codable, Equatable {
    
    case bush
    case flower
    case treeSmall
    case treeMedium
    case treeLarge
    case palmTree
    
    var identifier: String {
        
        switch self {
        
        case .bush: return "bush"
        case .flower: return "flower"
        case .treeSmall: return "tree_small"
        case .treeMedium: return "tree_medium"
        case .treeLarge: return "tree_large"
        case .palmTree: return "palm_tree"
        }
    }
    
    var texture: Texture? {
        
        guard let image = MDWImage.asset(named: "uvs", in: .module) else { return nil }
        
        return Texture(key: "foliage", image: image)
    }
}
