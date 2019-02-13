//
//  ArtDirector.swift
//  Meadow
//
//  Created by Zack Brown on 28/11/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import SceneKit

public class ArtDirector {
    
    public static let shared = ArtDirector()
    
    public let palettes: ColorPalettes
    
    public let colors: Colors
    
    var library: MTLLibrary? {
        
        if _library != nil { return _library }
        
        if let device = MTLCreateSystemDefaultDevice(), let bundle = Bundle.bundle(forPod: "Meadow") {
        
            _library = try? device.makeDefaultLibrary(bundle: bundle)
        }
        
        return _library
    }
    
    var _library: MTLLibrary?
    
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
        
        self.colors = Colors(children: Tree<Color>(colorIntermediates.sorted(by: { (lhs, rhs) -> Bool in
            
            return lhs.red > rhs.red && lhs.green > rhs.green && lhs.blue > rhs.blue
        })))
        
        self.palettes = ColorPalettes(children: Tree<ColorPalette>(colorPalettes.sorted(by: { (lhs, rhs) -> Bool in
            
            return lhs.name < rhs.name
        })))
    }
}

extension ArtDirector {
    
    public struct ColorPalettes {
        
        public let children: Tree<ColorPalette>
    }
    
    public func palette(named: String) -> ColorPalette? {
        
        let name = named.lowercased()
        
        return palettes.children.first { $0.name.lowercased() == name }
    }
}

extension ArtDirector {
    
    public struct Colors: Equatable {
        
        public let children: Tree<Color>
    }
    
    public func color(named: String) -> Color? {
        
        let name = named.lowercased()
        
        return colors.children.first { $0.name.lowercased() == name }
    }
}

extension ArtDirector {
    
    public func program(named: String) -> ShaderProgram {
        
        let shaderProgram = ShaderProgram(named: named)
        
        shaderProgram.library = library
        
        return shaderProgram
    }
}
