//
//  Size.swift
//  Meadow
//
//  Created by Zack Brown on 30/04/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

/*!
 @struct Size
 @abstract Defines a Size with width, height and depth components as an integer value.
 */
public struct Size: Codable {
    
    /*!
     @property width
     @abstract The width component of the Size.
     */
    public let width: Int
    
    /*!
     @property height
     @abstract The height component of the Size.
     */
    public let height: Int
    
    /*!
     @property depth
     @abstract The depth component of the Size.
     */
    public let depth: Int
    
    /*!
     @method init:width:height:depth
     @abstract Creates and initialises a Size with the specified width, depth and height components.
     @param width The width component of the Size.
     @param height The height component of the Size.
     @param depth The depth component of the Size.
     */
    public init(width: Int, height: Int, depth: Int) {
        
        self.width = width
        self.height = height
        self.depth = depth
    }
}

extension Size: Hashable {
    
    public static func == (lhs: Size, rhs: Size) -> Bool {
        
        return lhs.width == rhs.width && lhs.height == rhs.height && lhs.depth == rhs.depth
    }
    
    public var hashValue: Int {
        
        return width ^ height ^ depth
    }
}

extension Size {
    
    /*!
     @property Zero
     @abstract Returns a Size with the width, height and depth components set to 0.
     */
    public static var Zero: Size { return Size(width: 0, height: 0, depth: 0) }
    
    /*!
     @property One
     @abstract Returns a Size with the width, height and depth components set to 1.
     */
    public static var One: Size { return Size(width: 1, height: 1, depth: 1) }
}
