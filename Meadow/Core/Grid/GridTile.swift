//
//  GridTile.swift
//  GDH
//
//  Created by Zack Brown on 26/04/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

public class GridTile<Node: GridNode> {
    
    let coordinate: Coordinate
    
    init(coordinate: Coordinate) {
        
        self.coordinate = coordinate
    }
}

extension GridTile: Hashable {
    
    public static func == (lhs: GridTile<Node>, rhs: GridTile<Node>) -> Bool {
        
        return lhs.coordinate == rhs.coordinate
    }
    
    public var hashValue: Int {
        
        return coordinate.x ^ coordinate.y ^ coordinate.z
    }
}
