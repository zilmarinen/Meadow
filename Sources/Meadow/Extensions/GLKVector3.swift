//
//  GLKVector3.swift
//
//  Created by Zack Brown on 16/12/2020.
//

import GLKit

extension GLKVector3 {
    
    public init(vector: Vector) {
        
        self.init()
        
        self.x = Float(vector.x)
        self.y = Float(vector.y)
        self.z = Float(vector.z)
    }
}
