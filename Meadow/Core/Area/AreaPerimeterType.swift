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
    
    /*!
     @enum Identifier
     @abstract Defines a unique identifier for each AreaPerimeterType.
     */
    public enum Identifier: Int, Codable {
        
        case door
        case none
        case wall
        
        /*!
         @property description
         @abstract Returns the String value of the AreaPrefabType.
         */
        public var description: String {
            
            switch self {
                
            case .door: return "Door"
            case .none: return "None"
            case .wall: return "Wall"
            }
        }
        
        /*!
         @property all
         @abstract An array of all available Identifiers for AreaPerimeterTypes.
         */
        public static var all: [Identifier] { return [
            
            .door,
            .none,
            .wall
        ]}
    }
   
    /*!
     @property identifier
     @abstract Returns the Identifier for the AreaPerimeterType.
     */
    public var identifier: Identifier {
        
        switch self {
            
        case .door: return .door
        case .none: return .none
        case .wall: return .wall
        }
    }
    
    /*!
     @enum CodingKeys
     @abstract Defines the coding keys used when encoding this object.
     */
    private enum CodingKeys: Int, CodingKey {
        
        case identifier
        
        case door
        case none
        case wall
    }
    
    /*!
     @method init:identifier
     @abstract Creates and initialises a node with the specified Identifier.
     @param identifier The identifier of the AreaPerimeterType.
     */
    public init(identifier: Identifier) {
        
        switch identifier {
            
        case .door:
            
            self = .door(false)
            
        case .none:
            
            self = .none
            
        case .wall:
            
            self = .wall
        }
    }
    
    /*!
     @method init:from
     @abstract Creates and initialises a node, decoded by the provided decoder.
     @param decoder The decoder to read data from.
     */
    public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        if let identifier = try? container.decode(Identifier.self, forKey: .identifier) {
            
            switch identifier {
                
            case .door:
                
                let doorState = try container.decode(Bool.self, forKey: .door)
                
                self = .door(doorState)
                
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
        
        try container.encode(identifier, forKey: .identifier)
        
        switch self {
            
        case .door(let doorState):
            
            try container.encode(doorState, forKey: .door)
        
        default: break
        }
    }
}
