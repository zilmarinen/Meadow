//
//  AreaNode.swift
//  Meadow
//
//  Created by Zack Brown on 01/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

public class AreaNode: GridNode {
    
}

extension AreaNode {
    
    static var areaSize: Int = 6
    
    static func fixedVolume(_ coordinate: Coordinate) -> Volume {
        
        let size = Size(width: World.tileSize, height: areaSize, depth: World.tileSize)
        
        return Volume(coordinate: coordinate, size: size)
    }
}
