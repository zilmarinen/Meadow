//
//  Floor.swift
//  Meadow-iOS
//
//  Created by Zack Brown on 14/05/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

import SceneKit

public class Floor: SCNPlane {
    
    struct Uniform: ShaderUniform {
        
        let backgroundColor: vector_float4
        let gridColor: vector_float4
        
        let rendersGridLines: Bool
        
        init(backgroundColor: MDWColor, gridColor: MDWColor, rendersGridLines: Bool = false) {
            
            self.backgroundColor = vector_float4(Float(backgroundColor.redComponent), Float(backgroundColor.greenComponent), Float(backgroundColor.blueComponent), Float(backgroundColor.alphaComponent))
            
            self.gridColor = vector_float4(Float(gridColor.redComponent), Float(gridColor.greenComponent), Float(gridColor.blueComponent), Float(gridColor.alphaComponent))
            
            self.rendersGridLines = rendersGridLines
        }
    }
    
    public var backgroundColor: MDWColor = MDWColor(calibratedRed: 0.35, green: 0.35, blue: 0.35, alpha: 1) {
        
        didSet {
            
            set(uniform: uniform)
        }
    }
    
    public var gridColor: MDWColor = MDWColor(calibratedRed: 0, green: 0, blue: 0, alpha: 1) {
        
        didSet {
            
            set(uniform: uniform)
        }
    }
    
    public var rendersGridLines: Bool = false {
        
        didSet {
            
            set(uniform: uniform)
        }
    }
    
    var uniform: Uniform {
        
        return Uniform(backgroundColor: backgroundColor, gridColor: gridColor, rendersGridLines: rendersGridLines)
    }
    
    override init() {
        
        super.init()
        
        width = 1.5
        height = 1.5
        
        program = ShaderProgram(named: "floor")
        
        set(uniform: uniform)
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
}
