//
//  Map.swift
//  Meadow
//
//  Created by Zack Brown on 20/07/2019.
//  Copyright © 2019 Script Orchard. All rights reserved.
//

import Foundation

public struct Map {
    
    public let name: String
    
    public let intermediate: WorldIntermediate
    
    public init(name: String, intermediate: WorldIntermediate) {
        
        self.name = name
        
        self.intermediate = intermediate
    }
    
    public init?(named: String, inDirectory: String? = "Maps.scnassets") {
        
        let directory = "\(inDirectory ?? named)/\(named)"
        
        guard let path = Bundle.main.path(forResource: named, ofType: "meadow", inDirectory: directory) else { fatalError("Unable to load scene: \(named) in directory: \(directory) - file not found") }
        
        do {
            
            let url = URL(fileURLWithPath: path)
            
            let data = try Data(contentsOf: url)
            
            let decoder = JSONDecoder()
            
            let mapIntermediate = try decoder.decode(MapIntermediate.self, from: data)
            
            self.intermediate = mapIntermediate.world
            
            self.name = mapIntermediate.name
        }
        catch {
            
            fatalError("Unable to load scene: \(named) in directory: \(directory) - \(error)")
        }
    }
}
