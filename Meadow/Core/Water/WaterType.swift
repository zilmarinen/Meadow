//
//  WaterType.swift
//  Meadow-iOS
//
//  Created by Zack Brown on 05/06/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

/*!
 @class WaterType
 @abstract Named WaterType are used to paint WaterNodes with the appropriate ColorPalette.
 */
public struct WaterType: Codable {
    
    /*!
     @property name
     @abstract THe unique name of the WaterType.
     */
    public let name: String
    
    /*!
     @property colorPalette
     @abstract The color palette used to paint the WaterNodes.
     */
    public let colorPalette: ColorPalette
}

extension WaterType: Hashable {
    
    /*!
     @method ==
     @abstract Determine the equality of two WaterTypes.
     */
    public static func == (lhs: WaterType, rhs: WaterType) -> Bool {
        
        return lhs.name == rhs.name
    }
    
    /*!
     @property hashValue
     @abstract Return the hash value of the WaterType.
     */
    public var hashValue: Int {
        
        return name.hashValue
    }
}

extension WaterType {
    
    /*!
     @enum CodingKeys
     @abstract Defines the key value pairs for Codable types.
     */
    private enum CodingKeys: String, CodingKey {
        
        case name = "name"
        case colorPalette = "color_palette"
    }
}
