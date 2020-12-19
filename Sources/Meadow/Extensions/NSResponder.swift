//
//  NSResponder.swift
//
//  Created by Zack Brown on 17/11/2020.
//

import Foundation
import SceneKit

protocol Responder: Soilable {
    
    var responder: Responder? { get }
    
    var meadow: Meadow? { get }
    
    var library: MTLLibrary? { get }
}

extension Responder {
    
    var responder: Responder? { ancestor as? Responder }
    
    var meadow: Meadow? { responder?.meadow }
    
    var library: MTLLibrary? { responder?.library }
}
