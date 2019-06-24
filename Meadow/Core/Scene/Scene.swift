//
//  Scene.swift
//  Meadow
//
//  Created by Zack Brown on 08/05/2019.
//  Copyright © 2019 Script Orchard. All rights reserved.
//

import Foundation

public struct Scene {
    
    public let name: String
    
    public let intermediate: SceneIntermediate
    
    public init?(named: String, inDirectory: String? = "Scenes.scnassets") {
        
        let directory = "\(inDirectory ?? named)/\(named)"
        
        guard let path = Bundle.main.path(forResource: named, ofType: "meadow", inDirectory: directory) else { fatalError("Unable to load scene: \(named) in directory: \(directory) - file not found") }
        
        do {
            
            let url = URL(fileURLWithPath: path)
            
            let data = try Data(contentsOf: url)
            
            let decoder = JSONDecoder()
            
            self.intermediate = try decoder.decode(SceneIntermediate.self, from: data)
            
            self.name = named
        }
        catch {
            
            fatalError("Unable to load scene: \(named) in directory: \(directory) - \(error)")
        }
    }
}
