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
public enum AreaPerimeterType: Codable, Hashable {
    
    case door(Bool)
    case none
    case wall
    
    var rawValue: Int {
        
        switch self {
            
        case .door: return 0
        case .none: return 1
        case .wall: return 2
        }
    }
    
    /*!
     @enum CodingKeys
     @abstract Defines the coding keys used when encoding this object.
     */
    private enum CodingKeys: Int, CodingKey {
        
        case rawValue
        
        case door
        case none
        case wall
    }
    
    /*!
     @method init:from
     @abstract Creates and initialises a node, decoded by the provided decoder.
     @param decoder The decoder to read data from.
     */
    public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        if let rawValue = try? container.decode(Int.self, forKey: .rawValue) {
            
            switch rawValue {
                
            case 0:
                
                let door = try container.decode(Bool.self, forKey: .door)
                
                self = .door(door)
                
            default: break
            }
        }
        
        self = .none
    }
    
    /*!
     @method encode:to
     @abstract Encodes this object into the given encoder.
     @property encoder The encoder to use when encoding this object.
     */
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(rawValue, forKey: .rawValue)
        
        switch self {
            
        case .door(let door):
            
            try container.encode(door, forKey: .door)
        
        default: break
        }
    }
}
