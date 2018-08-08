//
//  FootpathNodeSlope.swift
//  Meadow
//
//  Created by Zack Brown on 27/07/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

extension FootpathNode {
    
    public struct Slope: Codable, Hashable {
        
        public let edge: GridEdge
        
        public let steep: Bool
        
        public init(edge: GridEdge, steep: Bool) {
            
            self.edge = edge
            
            self.steep = steep
        }
    }
}
