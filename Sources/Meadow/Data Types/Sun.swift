//
//  Sun.swift
//
//  Created by Zack Brown on 27/05/2021.
//

import SceneKit

class Sun: SCNNode, Responder, Soilable, Updatable {
    
    public var ancestor: SoilableParent?
    
    public var isDirty: Bool = false
    
    public var category: Int { SceneGraphCategory.sun.rawValue }
    
    public var source = SCNLight()
    
    override init() {
        
        super.init()
        
        name = "Sun"
        categoryBitMask = category
        light = source
        
        source.type = .omni
        source.color = Color(red: 1.0, green: 0.96, blue: 0.71).color
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
}

extension Sun {
    
    @discardableResult public func clean() -> Bool {
        
        guard isDirty else { return false }
        
        //
        
        isDirty = false
        
        return true
    }
}

extension Sun {
    
    public func update(delta: TimeInterval, time: TimeInterval) {
        
        position = SCNVector3(vector: Coordinate(x: 0, y: World.Constants.ceiling, z: 0).world)
    }
}
