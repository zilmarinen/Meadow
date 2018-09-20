//
//  ColorPalette.swift
//  Meadow
//
//  Created by Zack Brown on 09/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

public struct ColorPalette: Codable, Hashable {
    
    public let name: String
    
    public let primary: Color
    public let secondary: Color
    public let tertiary: Color
    public let quaternary: Color
    
    public var hashValue: Int { return name.hashValue }
    
    public static func == (lhs: ColorPalette, rhs: ColorPalette) -> Bool {
        
        return lhs.name == rhs.name
    }
}

public class ColorPalettes {
    
    public static let shared = ColorPalettes()
    
    let colorPalettes: [ColorPalette]
    
    let colors: [Color]
    
    public var allColors: [Color] { return colors }
    
    public var allColorPalettes: [ColorPalette] { return colorPalettes }
    
    init?() {
        
        guard let colorIntermediates = Color.load(filename: "colors") else { return nil }
        
        guard let colorPaletteIntermediates = ColorPaletteIntermediate.load(filename: "color_palettes") else { return nil }
        
        var palettes: [ColorPalette] = []
        
        colorPaletteIntermediates.forEach { intermediate in
            
            let primary = colorIntermediates.first { $0.name == intermediate.primary }
            let secondary = colorIntermediates.first { $0.name == intermediate.secondary }
            let tertiary = colorIntermediates.first { $0.name == intermediate.tertiary }
            let quaternary = colorIntermediates.first { $0.name == intermediate.quaternary }
            
            if let primary = primary, let secondary = secondary, let tertiary = tertiary, let quaternary = quaternary {
            
                palettes.append(ColorPalette(name: intermediate.name, primary: primary, secondary: secondary, tertiary: tertiary, quaternary: quaternary))
            }
        }
        
        self.colors = colorIntermediates
        
        self.colorPalettes = palettes
    }
}

extension ColorPalettes {
    
    public func color(named: String) -> Color? {
        
        return colors.first { $0.name == named }
    }
    
    public func palette(named: String) -> ColorPalette? {
        
        return colorPalettes.first { $0.name == named }
    }
}
