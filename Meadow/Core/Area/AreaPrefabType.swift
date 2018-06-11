//
//  AreaPrefabType.swift
//  Meadow-iOS
//
//  Created by Zack Brown on 11/06/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

/*!
 @enum AreaPrefabType
 @abstract Defines the AreaPrefabType of an AreaNode.
 */
public enum AreaPrefabType: Int, Codable {
    
    case concrete
    case sandstone
    case steel
    
    /*!
     @property description
     @abstract Returns the String value of the AreaPrefabType.
     */
    public var description: String {
        
        switch self {
        
        case .concrete: return "Concrete"
        case .sandstone: return "Sandstone"
        case .steel: return "Steel"
        }
    }
}

extension AreaPrefabType {
    
    /*!
     @property All
     @abstract An array of all available AreaPrefabTypes.
     */
    public static var All: [AreaPrefabType] { return [
        
        .concrete,
        .sandstone,
        .steel
    ]}
}
