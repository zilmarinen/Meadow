//
//  Sun.swift
//
//  Created by Zack Brown on 27/05/2021.
//

import Euclid
import SceneKit

class Sun: SCNNode, Responder, Soilable, Updatable {
    
    public var ancestor: SoilableParent?
    
    public var isDirty: Bool = false
    
    public var category: SceneGraphCategory { .sun }
    
    public var source = SCNLight()
    
    let color = Color(0.964, 0.933, 0.78)
    
    override init() {
        
        super.init()
        
        name = "Sun"
        categoryBitMask = category.rawValue
        position = SCNVector3(x: 10.0, y: 10.0, z: 10.0)
        light = source
        
        source.type = .omni
        source.color = color.osColor
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
        
        position = SCNVector3(Coordinate(x: 0, y: World.Constants.ceiling, z: World.Constants.ceiling).position)
    }
}
