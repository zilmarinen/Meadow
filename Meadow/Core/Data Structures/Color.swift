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
        
        return MDWColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    public var vector: SCNVector4 {
        
        return SCNVector4(x: red, y: green, z: blue, w: alpha)
    }
    
    public static func load(filename: String) -> [Color]? {
        
        do {
            
            guard let path = Bundle.meadow.path(forResource: filename, ofType: "json") else { return nil }
            
            let jsonData = try NSData(contentsOfFile: path) as Data
            
            let decoder = JSONDecoder()
            
            return try decoder.decode([Color].self, from: jsonData)
        }
        catch {
            
            fatalError("Unable to load Colors from file -> \(filename).json")
        }
    }
}
