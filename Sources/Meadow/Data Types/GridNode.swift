//
//  GridNode.swift
//
//  Created by Zack Brown on 07/12/2020.
//

public struct GridNode: Codable, Equatable, Hashable {
    
    public let coordinate: Coordinate
    public let cardinal: Cardinal
    
    public init(coordinate: Coordinate, cardinal: Cardinal) {
        
        self.coordinate = coordinate
        self.cardinal = cardinal
    }
}
