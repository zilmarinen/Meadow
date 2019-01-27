//
//  Actors.swift
//  Meadow
//
//  Created by Zack Brown on 12/11/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import SceneKit

public class Actors: SCNNode, SceneGraphChild, SceneGraphObserver, SceneGraphParent {
    
    public typealias ChildType = SCNNode
    
    public var observer: SceneGraphObserver?
    
    public var children: [SCNNode] { return childNodes }
    
    public var volume: Volume { return Volume(coordinate: Coordinate.zero, size: Size.one) }
    
    public let hero = Hero()
    
    public let npcs = NPCs()
    
    public override init() {
        
        super.init()
        
        hero.observer = self
        hero.name = "Hero"
        
        npcs.observer = self
        npcs.name = "NPCs"
        
        self.addChildNode(hero)
        self.addChildNode(npcs)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
}

extension Actors {
    
    public func index(of child: SCNNode) -> Int? {
        
        return childNodes.index(of: child)
    }
    
    public func child(didBecomeDirty child: SceneGraphChild) {
        
        observer?.child(didBecomeDirty: child)
    }
}
