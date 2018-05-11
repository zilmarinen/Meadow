//
//  SCNColor.swift
//  Meadow-iOS
//
//  Created by Zack Brown on 11/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

extension SCNColor {
    
    /*!
     @method init:red:green:blue:alpha
     @abstract Creates and initialises a platform specific color with the specified red, green, blue and alpha components.
     @param red The red component of the color.
     @param green The green component of the color.
     @param blue The blue component of the color.
     @param alpha The alpha component of the color.
     */
    convenience init(red: SCNFloat, green: SCNFloat, blue: SCNFloat, alpha: SCNFloat) {
        
        #if os(iOS)
        
        self.init(red: red, green: green, blue: blue, alpha: alpha)
        
        #else
        
        self.init(deviceRed: red, green: green, blue: blue, alpha: alpha)
        
        #endif
    }
}

