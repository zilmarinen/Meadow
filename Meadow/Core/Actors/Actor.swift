//
//  Actor.swift
//  Meadow
//
//  Created by Zack Brown on 25/04/2019.
//  Copyright © 2019 Script Orchard. All rights reserved.
//

import SceneKit

open class Actor: SCNNode, SceneGraphChild, SceneGraphSoilable, SceneGraphUpdatable {
    
    public var observer: SceneGraphObserver?
    
    var isDirty: Bool = false
    
    open override var isHidden: Bool {
        
        didSet {
            
            if isHidden != oldValue {
                
                becomeDirty()
            }
        }
    }
    
    public var volume: Volume { return Volume(coordinate: Coordinate.zero, size: Size.one) }
    
    public init(observer: SceneGraphObserver) {
        
        self.observer = observer
        
        super.init()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    open func update(deltaTime: TimeInterval) {
        
        clean()
    }
    
    @discardableResult public func becomeDirty() -> Bool {
        
        if !isDirty {
            
            isDirty = true
        }
        
        return isDirty
    }
    
    @discardableResult open func clean() -> Bool {
        
        if !isDirty { return false }
        
        //
        
        isDirty = false
        
        return true
    }
}
