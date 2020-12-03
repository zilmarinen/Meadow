//
//  NSResponder.swift
//
//  Created by Zack Brown on 17/11/2020.
//

import Foundation

protocol Responder: Soilable {
    
    var responder: Responder? { get }
    
    var tilemaps: Tilemaps? { get }
}

extension Responder {
    
    var responder: Responder? { ancestor as? Responder }
    
    var tilemaps: Tilemaps? { responder?.tilemaps }
}
