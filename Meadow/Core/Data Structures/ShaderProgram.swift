//
//  ShaderProgram.swift
//  Meadow
//
//  Created by Zack Brown on 06/02/2019.
//  Copyright © 2019 Script Orchard. All rights reserved.
//

import SceneKit

public class ShaderProgram: SCNProgram, SCNProgramDelegate {
    
    public init(named: String) {
        
        super.init()
        
        delegate = self
        fragmentFunctionName = "\(named)_fragment"
        vertexFunctionName = "\(named)_vertex"
    }
    
    public required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    public func program(_ program: SCNProgram, handleError error: Error) {
        
        print("SCNProgram error: \(error)")
    }
}
