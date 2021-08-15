//
//  BuildingType.swift  
//
//  Created by Zack Brown on 09/04/2021.
//

import Foundation

#if os(macOS)

    import AppKit

#else

    import UIKit

#endif

public enum BuildingType: Int, CaseIterable, Codable, Equatable {
    
    case house
    case home
    
    var identifier: String {
        
        switch self {
        
        case .house: return "house"
        case .home: return "home"
        }
    }
    
    var texture: Texture? {
        
        guard let image = MDWImage.asset(named: "uvs", in: .module) else { return nil }
        
        return Texture(key: "building", image: image)
    }
}
