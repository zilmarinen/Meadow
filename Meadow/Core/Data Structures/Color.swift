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
public struct Color: Codable {
    
    /*!
     @property red
     @abstract The red component of the Color.
     */
    let red: MDWFloat
    
    /*!
     @property green
     @abstract The green component of the Color.
     */
    let green: MDWFloat
    
    /*!
     @property blue
     @abstract The blue component of the Color.
     */
    let blue: MDWFloat
    
    /*!
     @property alpha
     @abstract The alpha component of the Color.
     */
    let alpha: MDWFloat
    
    /*!
     @property color
     @abstract Defines a color with the red, green, blue and alpha components.
     */
    var color: MDWColor {
        
        return MDWColor(red: red, green: green, blue: blue, alpha: alpha)
    }
}
