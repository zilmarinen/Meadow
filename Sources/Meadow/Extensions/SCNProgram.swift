//
//  SCNProgram.swift
//
//  Created by Zack Brown on 22/12/2020.
//

import SceneKit

extension SCNProgram {
    
    convenience init(name: String, library: MTLLibrary) {
        
        self.init()
        
        self.fragmentFunctionName = "\(name)_fragment"
        self.vertexFunctionName = "\(name)_vertex"
        self.library = library
        self.delegate = self
    }
}

extension SCNProgram: SCNProgramDelegate {
    
    public func program(_ program: SCNProgram, handleError error: Error) {
        
        print("SCNProgram error: \(error)")
    }
}
