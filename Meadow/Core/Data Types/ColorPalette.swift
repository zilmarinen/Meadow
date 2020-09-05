//
//  ColorPalette.swift
//  Meadow
//
//  Created by Zack Brown on 10/07/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

import Pasture

struct ColorPalette {
    
    let primary: Color
    let secondary: Color
}

extension ColorPalette {
    
    static let `default` = ColorPalette(primary: .black, secondary: .white)
}
