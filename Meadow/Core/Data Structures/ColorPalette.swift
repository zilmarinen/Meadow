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
    
    public static var shared = ColorPalettes()!
    
    let colorPalettes: [ColorPalette]
    
    public var all: [ColorPalette] { return colorPalettes }
    
    init?() {
        
        guard let colors = Color.load(filename: "colors") else { return nil }
        
        guard let intermediates = ColorPaletteIntermediate.load(filename: "color_palettes") else { return nil }
        
        var palettes: [ColorPalette] = []
        
        intermediates.forEach { intermediate in
            
            let primary = colors.first { $0.name == intermediate.primary }
            let secondary = colors.first { $0.name == intermediate.secondary }
            let tertiary = colors.first { $0.name == intermediate.tertiary }
            let quaternary = colors.first { $0.name == intermediate.quaternary }
            
            palettes.append(ColorPalette(name: intermediate.name, primary: primary!, secondary: secondary!, tertiary: tertiary!, quaternary: quaternary!))
        }
        
        self.colorPalettes = palettes
    }
}

extension ColorPalettes {
    
    public func palette(named: String) -> ColorPalette? {
        
        return colorPalettes.first { $0.name == named }
    }
}
