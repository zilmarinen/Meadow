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
    
    var identifier: String {
        
        switch self {
        
        case .house: return "house"
        }
    }
    
    public var model: Model? {
        
        guard let asset = NSDataAsset(name: identifier, bundle: .module) else { return nil }
    
        let decoder = JSONDecoder()
        
        return try? decoder.decode(Model.self, from: asset.data)
    }
}
