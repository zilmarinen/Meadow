//
//  SCNColor.swift
//  Meadow-iOS
//
//  Created by Zack Brown on 11/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

extension MDWColor {
    
    convenience init(red: MDWFloat, green: MDWFloat, blue: MDWFloat, alpha: MDWFloat) {
        
        #if os(iOS)
        
        self.init(red: red, green: green, blue: blue, alpha: alpha)
        
        #else
        
        self.init(deviceRed: red, green: green, blue: blue, alpha: alpha)
        
        #endif
    }
}

