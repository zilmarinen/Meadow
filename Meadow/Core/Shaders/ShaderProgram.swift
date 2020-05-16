//
//  ShaderProgram.swift
//  Meadow
//
//  Created by Zack Brown on 07/05/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

import SceneKit

class ShaderProgram: SCNProgram {
    
    init(named name: String) {
        
        super.init()
        
        self.fragmentFunctionName = "\(name)_fragment"
        self.vertexFunctionName = "\(name)_vertex"
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
}

extension ShaderProgram: SCNProgramDelegate {
    
    func program(_ program: SCNProgram, handleError error: Error) {
        
        print("SCNProgram error: \(error)")
    }
}
