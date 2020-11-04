//
//  SCNVector4.swift
//
//  Created by Zack Brown on 03/11/2020.
//

import SceneKit

extension SCNVector4{
    
    public init(color: Color) {
        
        self.init(color.red, color.green, color.blue, color.alpha)
    }
}
