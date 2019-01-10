//
//  PropPrototype.swift
//  Meadow
//
//  Created by Zack Brown on 21/11/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Foundation

public struct PropPrototype: Codable {
    
    public let name: String
    
    public let footprint: Footprint
    
    public init?(named: String) {
        
        let resource = named.lowercased().replacingOccurrences(of: " ", with: "_")
        
        do {
            
            guard let path = Bundle.meadow.path(forResource: resource, ofType: "prop") else { return nil }
            
            let data = try NSData(contentsOfFile: path) as Data
            
            let decoder = JSONDecoder()
            
            self = try decoder.decode(PropPrototype.self, from: data)
        }
        catch {
            
            fatalError("Unable to load Prop from file -> \(resource).prop")
        }
    }
}

extension PropPrototype: Equatable {
    
    public static func == (lhs: PropPrototype, rhs: PropPrototype) -> Bool {
        
        return lhs.name == rhs.name
    }
}
