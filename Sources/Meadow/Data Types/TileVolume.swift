//
//  TileVolume.swift
//
//  Created by Zack Brown on 11/05/2021.
//

import Foundation

public struct TileVolume: Codable {
    
    public struct Apex: Codable, Equatable {
        
        public let corners: [Double]
        
        public init(corners: [Double]) {
            
            self.corners = corners
        }
        
        public init(corners: Double) {
            
            self.corners = Array(repeating: corners, count: 4)
        }
    }
    
    public struct Edge: Codable {
        
        public let c0: Double
        public let c1: Double
    }
    
    public let apex: Apex
    public let edges: [Cardinal : [Ordinal : Double]]
    
    public init(apex: Apex, edges: [Cardinal : [Ordinal : Double]]) {
        
        self.apex = apex
        self.edges = edges
    }
}

extension TileVolume {
    
    static let apex: [Vector] = [
        
        Vector(x: -(World.Constants.volumeSize / 2.0), y: (Double(World.Constants.ceiling) * World.Constants.slope), z: -(World.Constants.volumeSize / 2.0)),
        Vector(x: (World.Constants.volumeSize / 2.0), y: (Double(World.Constants.ceiling) * World.Constants.slope), z: -(World.Constants.volumeSize / 2.0)),
        Vector(x: (World.Constants.volumeSize / 2.0), y: (Double(World.Constants.ceiling) * World.Constants.slope), z: (World.Constants.volumeSize / 2.0)),
        Vector(x: -(World.Constants.volumeSize / 2.0), y: (Double(World.Constants.ceiling) * World.Constants.slope), z: (World.Constants.volumeSize / 2.0))
    ]

    static let throne: [Vector] = [
        
        Vector(x: -(World.Constants.volumeSize / 2.0), y: 0, z: -(World.Constants.volumeSize / 2.0)),
        Vector(x: (World.Constants.volumeSize / 2.0), y: 0, z: -(World.Constants.volumeSize / 2.0)),
        Vector(x: (World.Constants.volumeSize / 2.0), y: 0, z: (World.Constants.volumeSize / 2.0)),
        Vector(x: -(World.Constants.volumeSize / 2.0), y: 0, z: (World.Constants.volumeSize / 2.0))
    ]
}
