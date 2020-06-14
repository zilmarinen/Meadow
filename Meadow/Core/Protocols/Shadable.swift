//
//  Shadable.swift
//  Meadow
//
//  Created by Zack Brown on 01/06/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

protocol Shadable {
    
    var shader: ShaderProgram { get }
    
    var uniform: ShaderUniform? { get }
}
