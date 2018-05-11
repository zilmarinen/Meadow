//
//  Color.swift
//  Meadow
//
//  Created by Zack Brown on 09/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import CoreGraphics

/*!
 @struct Color
 @abstract Defines a Color with red, green, blue and alpha components.
 */
public struct Color: Decodable {
    
    let red: CGFloat
    let green: CGFloat
    let blue: CGFloat
    let alpha: CGFloat
}
