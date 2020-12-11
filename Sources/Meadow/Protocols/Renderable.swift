//
//  Renderable.swift
//
//  Created by Zack Brown on 04/11/2020.
//

import SceneKit

protocol Renderable: Hideable {
 
    func render(position: Vector) -> [Polygon]
}
