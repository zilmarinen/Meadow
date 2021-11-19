//
//  WallMaterial.swift
//
//  Created by Zack Brown on 12/08/2021.
//

import Foundation
import SwiftUI

public enum WallMaterial: Int, CaseIterable, Codable, Hashable, Identifiable {
    
    case concrete
    case picket
    
    public var id: String {
        
        switch self {
        
        case .concrete: return "concrete"
        case .picket: return "picket"
        }
    }
}
