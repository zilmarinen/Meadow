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
    
    var identifier: String {
        
        switch self {
        
        case .bush: return "bush"
        case .flower: return "flower"
        case .treeSmall: return "tree_small"
        case .treeMedium: return "tree_medium"
        case .treeLarge: return "tree_large"
        }
    }
    
    public var model: Model? {
        print("LOADING MODEL: \(self.identifier)")
        guard let asset = NSDataAsset(name: identifier, bundle: .module) else { return nil }
    
        let decoder = JSONDecoder()
        
        return try? decoder.decode(Model.self, from: asset.data)
    }
    
    var texture: Texture? {
        
        #if os(macOS)
        
        guard let image = Bundle.module.image(forResource: "uvs") else { return nil }
        
        #else
        
        guard let image = MDWImage(named: "uvs", in: .module, with: nil) else { return nil }
        
        #endif
        
        return Texture(key: "foliage", image: image)
    }
}
