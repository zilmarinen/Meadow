//
//  ColorPaletteIntermediate.swift
//  Meadow
//
//  Created by Zack Brown on 27/07/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Foundation

public struct ColorPaletteIntermediate: Codable {
    
    let name: String
    
    let primary: String
    let secondary: String
    let tertiary: String
    let quaternary: String
    
    public static func load(filename: String) -> [ColorPaletteIntermediate]? {
        
        do {
            
            guard let path = Bundle.meadow.path(forResource: filename, ofType: "json") else { return nil }
            
            let jsonData = try NSData(contentsOfFile: path) as Data
            
            let decoder = JSONDecoder()
            
            return try decoder.decode([ColorPaletteIntermediate].self, from: jsonData)
        }
        catch {
            
            fatalError("Unable to load Colors Palettes from file -> \(filename).json")
        }
    }
}
