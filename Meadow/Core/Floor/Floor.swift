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
    
    public var backgroundColor: Color = .black {
        
        didSet {
            
            set(uniform: uniform)
        }
    }
    
    public var gridColor: Color = .white {
        
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
        
        return Uniform(worldFloor: World.Axis.y(y: World.Constants.floor), backgroundColor: backgroundColor, gridColor: gridColor, rendersGridLines: rendersGridLines)
    }
    
    override init() {
        
        super.init()
        
        width = 1.5
        height = 1.5
        
        program = ShaderProgram(named: "floor")
        program?.library = Stage.shaderLibrary
        
        set(uniform: uniform)
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
}
