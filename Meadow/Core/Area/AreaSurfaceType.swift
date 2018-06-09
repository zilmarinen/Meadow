//
//  AreaSurfaceType.swift
//  Meadow-iOS
//
//  Created by Zack Brown on 08/06/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

/*!
 @class AreaSurfaceType
 @abstract Named AreaSurfaceTypes are used to paint AreaNodes with the appropriate ColorPalette.
 */
public struct AreaSurfaceType: Codable {
    
    /*!
     @property name
     @abstract The unique name of the AreaSurfaceType.
     */
    public let name: String
    
    /*!
     @property colorPalette
     @abstract The color palette used to paint the AreaNode.
     */
    public let colorPalette: ColorPalette
}

extension AreaSurfaceType: Hashable {
    
    /*!
     @method ==
     @abstract Determine the equality of two AreaSurfaceType.
     */
    public static func == (lhs: AreaSurfaceType, rhs: AreaSurfaceType) -> Bool {
        
        return lhs.name == rhs.name
    }
    
    /*!
     @property hashValue
     @abstract Return the hash value of the AreaSurfaceType.
     */
    public var hashValue: Int {
        
        return name.hashValue
    }
}

extension AreaSurfaceType {
    
    /*!
     @enum CodingKeys
     @abstract Defines the key value pairs for Codable types.
     */
    private enum CodingKeys: String, CodingKey {
        
        case name = "name"
        case colorPalette = "color_palette"
    }
}

