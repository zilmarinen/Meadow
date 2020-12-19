//
//  ShaderUniform.swift
//
//  Created by Zack Brown on 18/12/2020.
//

import Foundation

protocol ShaderUniform {
    
    var key: String { get }
    var value: Data { get }
}

extension ShaderUniform {
    
    public var key: String { "uniforms" }
    
    public var value: Data {
        
        var this = self
        
        return Data(bytes: &this, count: MemoryLayout<Self>.stride)
    }
}
