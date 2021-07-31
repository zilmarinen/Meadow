//
//  Renderable.swift
//
//  Created by Zack Brown on 04/11/2020.
//

import Euclid
import SceneKit

protocol Renderable: Hideable {
 
    func render(position: Vector) -> [Euclid.Polygon]
}
