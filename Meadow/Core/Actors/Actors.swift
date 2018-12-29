//
//  Actors.swift
//  Meadow
//
//  Created by Zack Brown on 12/11/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import SceneKit

public class Actors: SCNNode, SceneGraphChild, SceneGraphParent {
    
    public let hero = Hero()
    
    public let npcs = NPCs()
    
    public override init() {
        
        super.init()
        
        hero.name = "Hero"
        
        npcs.name = "NPCs"
        
        self.addChildNode(hero)
        self.addChildNode(npcs)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
}

extension Actors {
    
    public var totalChildren: Int { return childNodes.count }
    
    public func child(at index: Int) -> SceneGraphChild? {
        
        return childNodes[index] as? SceneGraphChild
    }
    
    public func index(of child: SceneGraphChild) -> Int? {
        
        guard let child = child as? SCNNode else { return nil }
        
        return childNodes.index(of: child)
    }
}
