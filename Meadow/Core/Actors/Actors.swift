//
//  Actors.swift
//  Meadow
//
//  Created by Zack Brown on 12/11/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import SceneKit

public class Actors: SCNNode, SceneGraphChild, SceneGraphObserver, SceneGraphParent {
    
    var children = Tree<SCNNode>()
    
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
    
    public var hero: Hero? {
        
        didSet {
            
            if let oldValue = oldValue {
                
                oldValue.observer = nil
                
                if children.remove(oldValue) {
                 
                    oldValue.removeFromParentNode()
                }
            }
            
            if hero != oldValue, let hero = hero {
                
                hero.observer = self
                
                self.addChildNode(hero)
            }
        }
    }
    
    public let npcs = NPCs()
    
    public override init() {
        
        super.init()
        
        npcs.observer = self
        npcs.name = "NPCs"
        
        self.addChildNode(npcs)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func addChildNode(_ child: SCNNode) {
        
        if children.append(child) {
            
            super.addChildNode(child)
        }
    }
}

extension Actors: SceneGraphUpdatable {
    
    public func update(deltaTime: TimeInterval) {
        
        children.forEach { child in
            
            if let child = child as? SceneGraphUpdatable {
                
                child.update(deltaTime: deltaTime)
            }
        }
        
        clean()
    }
}

extension Actors {
    
    public var totalChildren: Int { return children.count }
    
    public func child(at index: Int) -> SceneGraphChild? {
        
        return children[index] as? SceneGraphChild
    }
    
    public func index(of child: SceneGraphChild) -> Int? {
        
        guard let child = child as? SCNNode else { return nil }
        
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
            
            if let child = child as? SceneGraphSoilable {
            
                child.clean()
            }
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
