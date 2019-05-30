//
//  Actors.swift
//  Meadow
//
//  Created by Zack Brown on 12/11/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import SceneKit

public class Actors: SCNNode, SceneGraphChild, SceneGraphObserver, SceneGraphParent {
    
    var children = Tree<Actor>()
    
    public var observer: SceneGraphObserver?
    
    var isDirty: Bool = false
    
    public override var isHidden: Bool {
        
        didSet {
            
            if isHidden != oldValue {
                
                becomeDirty()
            }
        }
    }
    
    public var volume: Volume { return Volume(coordinate: Coordinate.zero, size: Size.one) }
    
    public override func addChildNode(_ child: SCNNode) {
        
        guard let child = child as? Actor else { return }
        
        if children.append(child) {
            
            super.addChildNode(child)
            
            becomeDirty()
        }
    }
}

extension Actors: SceneGraphUpdatable {
    
    public func update(deltaTime: TimeInterval) {
        
        children.forEach { child in
            
            child.update(deltaTime: deltaTime)
        }
        
        clean()
    }
}

extension Actors {
    
    public var totalChildren: Int { return children.count }
    
    public func child(at index: Int) -> SceneGraphChild? {
        
        return children[index]
    }
    
    public func index(of child: SceneGraphChild) -> Int? {
        
        guard let child = child as? Actor else { return nil }
        
        return children.index(of: child)
    }
}

extension Actors: SceneGraphSoilable {
    
    @discardableResult public func becomeDirty() -> Bool {
        
        if !isDirty {
            
            isDirty = true
        }
        
        return isDirty
    }
    
    @discardableResult public func clean() -> Bool {
        
        if !isDirty { return false }
        
        children.forEach { child in
        
            child.clean()
        }
        
        isDirty = false
        
        return true
    }
}

extension Actors {
    
    public func child(didBecomeDirty child: SceneGraphChild) {
        
        observer?.child(didBecomeDirty: child)
    }
}

extension Actors {
    
    public func add(actor: Actor) -> Bool {
        
        if children.index(of: actor) == nil {
            
            addChildNode(actor)
            
            becomeDirty()
        }
        
        return false
    }
    
    public func remove(actor: Actor) -> Bool {
        
        if children.remove(actor) {
            
            actor.removeFromParentNode()
            
            actor.observer = nil
            
            becomeDirty()
            
            return true
        }
        
        return false
    }
}
