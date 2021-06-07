//
//  NSResponder.swift
//
//  Created by Zack Brown on 17/11/2020.
//

import Foundation
import SceneKit

protocol Responder: Soilable {
    
    var responder: Responder? { get }
    
    var scene: Scene? { get }
    var map: Meadow? { get }
}

extension Responder {
    
    var responder: Responder? { ancestor as? Responder }
    
    var scene: Scene? { responder?.scene }
    var map: Meadow? { responder?.map }
}
