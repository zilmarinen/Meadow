//
//  NSResponder.swift
//
//  Created by Zack Brown on 17/11/2020.
//

import Foundation
import SceneKit

public protocol Responder: Soilable {
    
    var responder: Responder? { get }
    
    var scene: Scene? { get }
    var map: Map? { get }
}

public extension Responder {
    
    var responder: Responder? { ancestor as? Responder }
    
    var scene: Scene? { responder?.scene }
    var map: Map? { responder?.map }
}
