//
//  Actors.swift
//  Meadow
//
//  Created by Zack Brown on 23/04/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

import SceneKit

public class Actors: SCNNode, SceneGraphIdentifiable, SceneGraphNode {
    
    var npcs: NPCs = NPCs()
    
    override public init() {
    
        super.init()
        
        name = "Actors"
        
        addChildNode(npcs)
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    public var children: [SceneGraphNode] { return [npcs] }
    
    public var childCount: Int { return children.count }
    
    public var isLeaf: Bool { return children.isEmpty }
    
    public var category: SceneGraphNodeCategory { .actors }
    
    public var type: SceneGraphNodeType { return .grid }
}

extension Actors: Updatable {
    
    func update(delta: TimeInterval, time: TimeInterval) {
        
        npcs.update(delta: delta, time: time)
    }
}
