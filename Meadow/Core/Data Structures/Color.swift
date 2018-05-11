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
    
    /*!
     @property red
     @abstract The red component of the Color.
     */
    let red: SCNFloat
    
    /*!
     @property green
     @abstract The green component of the Color.
     */
    let green: SCNFloat
    
    /*!
     @property blue
     @abstract The blue component of the Color.
     */
    let blue: SCNFloat
    
    /*!
     @property alpha
     @abstract The alpha component of the Color.
     */
    let alpha: SCNFloat
    
    /*!
     @property color
     @abstract Defines a color with the red, green, blue and alpha components.
     */
    var color: SCNColor {
        
        return SCNColor(red: red, green: green, blue: blue, alpha: alpha)
    }
}
