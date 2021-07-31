//
//  Uniform.swift
//
//  Created by Zack Brown on 18/12/2020.
//

import Foundation

public protocol Uniform {
    
    var key: String { get }
    var value: Data { get }
}

extension Uniform {
    
    public var key: String { "uniforms" }
    
    public var value: Data {
        
        var ref = self
        
        return Data(bytes: &ref, count: MemoryLayout<Self>.stride)
    }
}
