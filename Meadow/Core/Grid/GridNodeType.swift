//
//  GridNodeType.swift
//  Meadow-iOS
//
//  Created by Zack Brown on 21/07/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Foundation

public protocol GridNodeType: Codable, Hashable {
    
    var name: String { get }
}

extension GridNodeType {
    
    public static func load(filename: String) -> [Self]? {
        
        do {
            
            guard let path = Bundle.meadow.path(forResource: filename, ofType: "json") else { return nil }
            
            let jsonData = try NSData(contentsOfFile: path) as Data
            
            let decoder = JSONDecoder()
            
            return try decoder.decode([Self].self, from: jsonData)
        }
        catch {
            
            fatalError("Unable to load GridNodeType -> \(filename)")
        }
    }
}
