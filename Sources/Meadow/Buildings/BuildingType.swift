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

public enum BuildingType: Int, CaseIterable, Codable, Equatable, Identifiable {
    
    case bernina_f
    case bernina_i
    case bernina_l
    case bernina_n
    case bernina_t
    case bernina_u
    case bernina_y
    case bernina_z
    
    public var id: String {
        
        switch self {
        
        case .bernina_f: return "bernina_f"
        case .bernina_i: return "bernina_i"
        case .bernina_l: return "bernina_l"
        case .bernina_n: return "bernina_n"
        case .bernina_t: return "bernina_t"
        case .bernina_u: return "bernina_u"
        case .bernina_y: return "bernina_y"
        case .bernina_z: return "bernina_z"
        }
    }
    
    var texture: Texture? {
        
        guard let image = MDWImage.asset(named: "building_bernina", in: .module) else { return nil }
        
        return Texture(key: "image", image: image)
    }
}
