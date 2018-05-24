//
//  TerrainType.swift
//  Meadow
//
//  Created by Zack Brown on 05/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

/*!
 @class TerrainType
 @abstract Named TerrainTypes are used to paint TerrainLayers with the appropriate ColorPalette.
 */
public struct TerrainType: Codable {
    
    /*!
     @property name
     @abstract THe unique name of the terrain type.
     */
    public let name: String
    
    /*!
     @property colorPalette
     @abstract The color palette used to paint the terrain.
     */
    public let colorPalette: ColorPalette
}

extension TerrainType: Hashable {
    
    /*!
     @method ==
     @abstract Determine the equality of two TerrainTypes.
     */
    public static func == (lhs: TerrainType, rhs: TerrainType) -> Bool {
        
        return lhs.name == rhs.name
    }
    
    /*!
     @property hashValue
     @abstract Return the has value of the TerrainType.
     */
    public var hashValue: Int {
        
        return name.hashValue
    }
}

extension TerrainType {
    
    /*!
     @enum CodingKeys
     @abstract Defines the key value pairs for Codable types.
     */
    private enum CodingKeys: String, CodingKey {
        
        case name = "name"
        case colorPalette = "color_palette"
    }
}
