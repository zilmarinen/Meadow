//
//  Color.swift
//  Meadow
//
//  Created by Zack Brown on 09/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

/*!
 @struct Color
 @abstract Defines a Color with red, green, blue and alpha components.
 */
public struct Color: Decodable {
    
    let red: SCNFloat
    let green: SCNFloat
    let blue: SCNFloat
    let alpha: SCNFloat
    
    /*!
     @property color
     @abstract Defines a color with the red, green, blue and alpha components.
     */
    var color: SCNColor {
        
        return SCNColor(red: red, green: green, blue: blue, alpha: alpha)
    }
}
