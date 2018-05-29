//
//  FootpathType.swift
//  Meadow-iOS
//
//  Created by Zack Brown on 28/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

/*!
 @class FootpathType
 @abstract Named FootpathTypes are used to paint FootpathNodes with the appropriate ColorPalette.
 */
public struct FootpathType: Codable {
    
    /*!
     @property name
     @abstract The unique name of the FootpathType.
     */
    public let name: String
    
    /*!
     @property colorPalette
     @abstract The color palette used to paint the FootpathNode.
     */
    public let colorPalette: ColorPalette
}

extension FootpathType: Hashable {
    
    /*!
     @method ==
     @abstract Determine the equality of two FootpathTypes.
     */
    public static func == (lhs: FootpathType, rhs: FootpathType) -> Bool {
        
        return lhs.name == rhs.name
    }
    
    /*!
     @property hashValue
     @abstract Return the hash value of the FootpathType.
     */
    public var hashValue: Int {
        
        return name.hashValue
    }
}

extension FootpathType {
    
    /*!
     @enum CodingKeys
     @abstract Defines the key value pairs for Codable types.
     */
    private enum CodingKeys: String, CodingKey {
        
        case name = "name"
        case colorPalette = "color_palette"
    }
}
