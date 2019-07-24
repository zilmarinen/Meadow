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
}
