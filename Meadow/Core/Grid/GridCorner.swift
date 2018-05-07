//
//  GridCorner.swift
//  Meadow
//
//  Created by Zack Brown on 27/04/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

public enum GridCorner: Int {
    
    case northWest
    case northEast
    case southEast
    case southWest
}

extension GridCorner {
    
    static var Corners: [GridCorner] { return [
    
        .northWest,
        .northEast,
        .southEast,
        .southWest
    ]}
    
    private static var Connected: [[GridCorner]] { return [
        
        [.northEast, .southWest],
        [.northWest, .southEast],
        [.northEast, .southWest],
        [.northWest, .southEast],
    ]}
    
    static func Connected(corner: GridCorner) -> [GridCorner] {
        
        return Connected[corner.rawValue]
    }
}
