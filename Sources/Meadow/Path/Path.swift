//
//  Path.swift
//
//  Created by Zack Brown on 07/12/2020.
//

public struct Path {
    
    public let nodes: [PathNode]
    
    public func node(for coordinate: Coordinate) -> PathNode? {
        
        return nodes.first { $0.coordinate.xz == coordinate.xz }
    }
}
