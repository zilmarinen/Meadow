//
//  AreaNode.swift
//  Meadow
//
//  Created by Zack Brown on 01/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

public class AreaNode: GridNode {
    
    var edges = Edges()
    
    var internalAreaType: AreaType? {
        
        didSet {
            
            if internalAreaType != oldValue {
                
                becomeDirty()
            }
        }
    }
    
    var externalAreaType: AreaType? {
        
        didSet {
            
            if externalAreaType != oldValue {
                
                becomeDirty()
            }
        }
    }
    
    enum CodingKeys: CodingKey {
        
        case name
        case edges
        case internalAreaType
        case externalAreaType
    }
    
    public override func encode(to encoder: Encoder) throws {
        
        try super.encode(to: encoder)
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(self.name, forKey: .name)
        try container.encode(self.edges, forKey: .edges)
        try container.encode(self.internalAreaType, forKey: .internalAreaType)
        try container.encode(self.externalAreaType, forKey: .externalAreaType)
    }
}

extension AreaNode {
    
    static var areaSize: Int = 6
    
    static func fixedVolume(_ coordinate: Coordinate) -> Volume {
        
        let size = Size(width: World.tileSize, height: areaSize, depth: World.tileSize)
        
        return Volume(coordinate: coordinate, size: size)
    }
}
