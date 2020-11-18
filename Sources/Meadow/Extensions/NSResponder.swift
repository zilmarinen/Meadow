//
//  NSResponder.swift
//
//  Created by Zack Brown on 17/11/2020.
//

import Foundation

protocol Responder: Soilable {
    
    var responder: Responder? { get }
    
    var season: Season? { get }
}

extension Responder {
    
    var responder: Responder? { ancestor as? Responder }
    
    var season: Season? { responder?.season }
}
