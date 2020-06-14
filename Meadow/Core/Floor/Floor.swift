//
//  Floor.swift
//  Meadow-iOS
//
//  Created by Zack Brown on 14/05/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

import Pasture
import SceneKit

public class Floor: SCNPlane, Shadable {
    
    struct Uniform: ShaderUniform {
        
        let worldFloor: float_t
        
        let backgroundColor: vector_float4
        let gridColor: vector_float4
        
        let rendersGridLines: Bool
        
        init(worldFloor: Double, backgroundColor: Color, gridColor: Color, rendersGridLines: Bool = false) {
            
            self.worldFloor = float_t(worldFloor)
            
            self.backgroundColor = backgroundColor.uniform
            
            self.gridColor = gridColor.uniform
            
            self.rendersGridLines = rendersGridLines
        }
    }
    
    var shader: ShaderProgram {
        
        let program = ShaderProgram(named: "floor")
        
        program.library = Stage.shaderLibrary
        
        return program
    }
    
    var uniform: ShaderUniform? {
        
        return Uniform(worldFloor: World.Axis.y(y: World.Constants.floor), backgroundColor: backgroundColor, gridColor: gridColor, rendersGridLines: rendersGridLines)
    }
    
    public var backgroundColor: Color = .grey {
        
        didSet {
            
            guard let uniform = uniform else { return }
            
            set(uniform: uniform)
        }
    }
    
    public var gridColor: Color = .white {
        
        didSet {
            
            guard let uniform = uniform else { return }
            
            set(uniform: uniform)
        }
    }
    
    public var rendersGridLines: Bool = false {
        
        didSet {
            
            guard let uniform = uniform else { return }
            
            set(uniform: uniform)
        }
    }
    
    override init() {
        
        super.init()
        
        width = 2
        height = 2
        
        program = shader
        
        guard let uniform = uniform else { return }
        
        set(uniform: uniform)
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
}
