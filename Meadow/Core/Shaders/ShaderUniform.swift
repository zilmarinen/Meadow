//
//  ShaderUniform.swift
//  Meadow
//
//  Created by Zack Brown on 14/05/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

public protocol ShaderUniform {
    
    var key: String { get }
    
    var bytes: Data { get }
}

extension ShaderUniform {
    
    public var key: String { return "uniform" }
    
    public var bytes: Data {
        
        var copy = self
        
        return Data(bytes: &copy, count: MemoryLayout<Self>.stride)
    }
}
