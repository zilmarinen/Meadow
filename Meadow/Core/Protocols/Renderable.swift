//
//  Renderable.swift
//  Meadow
//
//  Created by Zack Brown on 07/02/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

import Pasture

protocol Renderable: Hideable {
    
    var mesh: Mesh { get }
    
    var transform: Transform { get }
    
    func render(transform: Transform) -> Mesh
}
