//
//  Color.swift
//  Meadow
//
//  Created by Zack Brown on 09/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import SceneKit

public struct Color: Codable, Hashable {
    
    public let name: String
    
    public let red: MDWFloat
    public let green: MDWFloat
    public let blue: MDWFloat
    public let alpha: MDWFloat
    
    public var color: MDWColor {
        
        return MDWColor(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: CGFloat(alpha))
    }
    
    public var vector: SCNVector4 {
        
        return SCNVector4(x: red, y: green, z: blue, w: alpha)
    }
}

extension Color {
    
    public static func load(colors: String) -> [Color]? {
        
        let resource = colors.lowercased().replacingOccurrences(of: " ", with: "_")
        
        do {
            
            guard let path = Bundle.meadow.path(forResource: resource, ofType: "json") else { return nil }
            
            let data = try NSData(contentsOfFile: path) as Data
            
            let decoder = JSONDecoder()
            
            return try decoder.decode([Color].self, from: data)
        }
        catch {
            
            fatalError("Unable to load Colors from file -> \(resource).json")
        }
    }
}
