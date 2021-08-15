//
//  StairType.swift
//
//  Created by Zack Brown on 19/05/2021.
//

import Foundation
import SwiftUI

public enum StairType: Int, CaseIterable, Codable, Equatable, Identifiable {
    
    case sloped_1x1
    case sloped_2x1
    
    case sloped_1x2
    case sloped_2x2
    
    case steep_1x1
    case steep_2x1
    
    case steep_1x2
    case steep_2x2
    
    public var id: String {
        
        switch self {
            
        case .sloped_1x1: return "sloped 1x1"
        case .sloped_2x1: return "sloped 2x1"
        case .sloped_1x2: return "sloped 1x2"
        case .sloped_2x2: return "sloped 2x2"
            
        case .steep_1x1: return "steep 1x1"
        case .steep_2x1: return "steep 2x1"
        case .steep_1x2: return "steep 1x2"
        case .steep_2x2: return "steep 2x2"
        }
    }
}
