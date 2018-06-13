//
//  AreaMaterialType.swift
//  Meadow-iOS
//
//  Created by Zack Brown on 13/06/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

/*!
 @class AreaMaterialType
 @abstract Named AreaMaterialType are used to paint the perimeter of an AreaNode with the appropriate ColorPalette.
 */
public struct AreaMaterialType: Codable {
    
    /*!
     @property name
     @abstract The unique name of the AreaMaterialType.
     */
    public let name: String
    
    /*!
     @property colorPalette
     @abstract The color palette used to paint the AreaMaterialType.
     */
    public let colorPalette: ColorPalette
}

extension AreaMaterialType: Hashable {
    
    /*!
     @method ==
     @abstract Determine the equality of two AreaMaterialType.
     */
    public static func == (lhs: AreaMaterialType, rhs: AreaMaterialType) -> Bool {
        
        return lhs.name == rhs.name
    }
    
    /*!
     @property hashValue
     @abstract Return the hash value of the AreaMaterialType.
     */
    public var hashValue: Int {
        
        return name.hashValue
    }
}

extension AreaMaterialType {
    
    /*!
     @enum CodingKeys
     @abstract Defines the key value pairs for Codable types.
     */
    private enum CodingKeys: String, CodingKey {
        
        case name = "name"
        case colorPalette = "color_palette"
    }
}

