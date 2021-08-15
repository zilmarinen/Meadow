//
//  StairMaterial.swift
//
//  Created by Zack Brown on 15/08/2021.
//

import Foundation
import SwiftUI

public enum StairMaterial: Int, CaseIterable, Codable, Equatable, Identifiable {
    
    case stone
    
    public var id: String {
        
        switch self {
        
        case .stone: return "stone"
        }
    }
}
