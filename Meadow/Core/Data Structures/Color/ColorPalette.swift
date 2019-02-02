//
//  ColorPalette.swift
//  Meadow
//
//  Created by Zack Brown on 09/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

public struct ColorPalette: Codable {
    
    public let name: String
    
    public let primary: Color
    public let secondary: Color
    public let tertiary: Color
    public let quaternary: Color
}

extension ColorPalette: Hashable {
    
    public var hashValue: Int { return name.hashValue }
    
    public static func == (lhs: ColorPalette, rhs: ColorPalette) -> Bool {
        
        return lhs.name == rhs.name
    }
}

extension ColorPalette {
    
    public var totalChildren: Int { return 4 }
    
    public func child(at index: Int) -> Color? {
        
        switch index {
            
        case 0: return primary
        case 1: return secondary
        case 2: return tertiary
        case 3: return quaternary
            
        default: return nil
        }
    }
    
    public func index(of child: Color) -> Int? {
        
        switch child {
            
        case primary: return 0
        case secondary: return 1
        case tertiary: return 2
        case quaternary: return 3
            
        default: return nil
        }
    }
}
