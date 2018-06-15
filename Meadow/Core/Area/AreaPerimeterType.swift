//
//  AreaPerimeterType.swift
//  Meadow-iOS
//
//  Created by Zack Brown on 09/06/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Foundation

/*!
 @enum AreaPerimeterType
 @abstract Defines the type of the perimeter of an AreaNode along a specific GridEdge.
 */
public enum AreaPerimeterType: Int, Codable {
    
    case doorway
    case wall
    case window
    
    /*!
     @property description
     @abstract Returns the String value of the AreaPrefabType.
     */
    public var description: String {
        
        switch self {
            
        case .doorway: return "Doorway"
        case .wall: return "Wall"
        case .window: return "Window"
        }
    }
}

extension AreaPerimeterType {
    
    /*!
     @property all
     @abstract An array of all available AreaPerimeterType.
     */
    public static var all: [AreaPerimeterType] { return [
        
        .doorway,
        .wall,
        .window
    ]}
}
