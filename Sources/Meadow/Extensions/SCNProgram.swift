//
//  SCNProgram.swift
//
//  Created by Zack Brown on 22/12/2020.
//

import SceneKit

extension SCNProgram {
    
    enum Name: String {
        
        case building
        case foliage
        case footpath
        case surface
        case water
    }
    
    convenience init(name: Name, library: MTLLibrary) {
        
        self.init()
        
        self.fragmentFunctionName = "\(name.rawValue)_fragment"
        self.vertexFunctionName = "\(name.rawValue)_vertex"
        self.library = library
        self.delegate = self
    }
}

extension SCNProgram: SCNProgramDelegate {
    
    public func program(_ program: SCNProgram, handleError error: Error) {
        
        print("SCNProgram error: \(error)")
    }
}
