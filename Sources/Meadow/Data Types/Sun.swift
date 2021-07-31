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
    
    let color = Color(red: 0.964, green: 0.933, blue: 0.78)
    
    override init() {
        
        super.init()
        
        name = "Sun"
        categoryBitMask = category
        light = source
        
        source.type = .omni
        source.color = color.color
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
        
        position = SCNVector3(Coordinate(x: 0, y: World.Constants.ceiling, z: World.Constants.ceiling).world)
    }
}
