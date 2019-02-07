//
//  ShaderProgram.swift
//  Meadow
//
//  Created by Zack Brown on 06/02/2019.
//  Copyright © 2019 Script Orchard. All rights reserved.
//

import SceneKit

class ShaderProgram: SCNProgram, SCNProgramDelegate {
    
    init?(named: String) {
        
        super.init()
        
        delegate = self
        fragmentFunctionName = "\(named)_fragment"
        vertexFunctionName = "\(named)_vertex"
        
        setSemantic(SCNGeometrySource.Semantic.vertex.rawValue, forSymbol: "vertex", options: nil)
        setSemantic(SCNGeometrySource.Semantic.color.rawValue, forSymbol: "color", options: nil)
        setSemantic(SCNGeometrySource.Semantic.normal.rawValue, forSymbol: "normal", options: nil)
        
        setSemantic(SCNModelViewTransform, forSymbol: "modelViewMatrix", options: nil)
        setSemantic(SCNModelViewProjectionTransform, forSymbol: "projectionMatrix", options: nil)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    public func program(_ program: SCNProgram, handleError error: Error) {
        
        print("error: \(error)")
    }
}
