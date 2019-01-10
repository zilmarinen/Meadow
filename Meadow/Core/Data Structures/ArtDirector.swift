//
//  ArtDirector.swift
//  Meadow
//
//  Created by Zack Brown on 28/11/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

public class ArtDirector {
    
    public static let shared = ArtDirector()
    
    public let palettes: ColorPalettes
    
    public let colors: Colors
    
    init?() {
        
        guard let colorIntermediates = Color.load(colors: "colors") else { return nil }
        
        guard let colorPaletteIntermediates = ColorPaletteIntermediate.load(palettes: "color_palettes") else { return nil }
        
        var colorPalettes: [ColorPalette] = []
        
        colorPaletteIntermediates.forEach { intermediate in
            
            let primary = colorIntermediates.first { $0.name == intermediate.primary }
            let secondary = colorIntermediates.first { $0.name == intermediate.secondary }
            let tertiary = colorIntermediates.first { $0.name == intermediate.tertiary }
            let quaternary = colorIntermediates.first { $0.name == intermediate.quaternary }
            
            if let primary = primary, let secondary = secondary, let tertiary = tertiary, let quaternary = quaternary {
                
                colorPalettes.append(ColorPalette(name: intermediate.name, primary: primary, secondary: secondary, tertiary: tertiary, quaternary: quaternary))
            }
        }
        
        self.colors = Colors(colors: colorIntermediates.sorted(by: { (lhs, rhs) -> Bool in
            
            return lhs.red > rhs.red && lhs.green > rhs.green && lhs.blue > rhs.blue
        }))
        
        self.palettes = ColorPalettes(palettes: colorPalettes.sorted(by: { (lhs, rhs) -> Bool in
            
            return lhs.name < rhs.name
        }))
    }
}

extension ArtDirector {
    
    public struct ColorPalettes: TreeParent {
        
        public typealias TreeChild = ColorPalette
        
        let palettes: [TreeChild]
        
        public var totalChildren: Int { return palettes.count }
        
        public func child(at index: Int) -> TreeChild? {
            
            return palettes[index]
        }
        
        public func index(of child: TreeChild) -> Int? {
            
            return palettes.index(of: child)
        }
    }
    
    public func palette(named: String) -> ColorPalette? {
        
        let name = named.lowercased()
        
        return palettes.palettes.first { $0.name.lowercased() == name }
    }
}

extension ArtDirector {
    
    public struct Colors: TreeParent {
        
        public typealias TreeChild = Color
        
        let colors: [TreeChild]
        
        public var totalChildren: Int { return colors.count }
        
        public func child(at index: Int) -> TreeChild? {
            
            return colors[index]
        }
        
        public func index(of child: TreeChild) -> Int? {
            
            return colors.index(of: child)
        }
    }
    
    public func color(named: String) -> Color? {
        
        let name = named.lowercased()
        
        return colors.colors.first { $0.name.lowercased() == name }
    }
}
