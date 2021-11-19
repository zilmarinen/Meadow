//
//  BridgeMaterial.swift
//
//  Created by Zack Brown on 15/08/2021.
//

import Foundation
import SwiftUI

public enum BridgeMaterial: Int, CaseIterable, Codable, Hashable, Identifiable {
    
    case stone
    case wood
    
    public var id: String {
        
        switch self {
            
        case .stone: return "stone"
        case .wood: return "wood"
        }
    }
}
