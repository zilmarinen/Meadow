//
//  NPCs.swift
//  Meadow
//
//  Created by Zack Brown on 23/04/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

import SceneKit

public class NPCs: SCNNode, SceneGraphIdentifiable, SceneGraphNode {
    
    public weak var ancestor: SoilableParent?
    
    public init(ancestor: SoilableParent) {
        
        self.ancestor = ancestor
        
        super.init()
        
        name = "NPCs"
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    public var children: [SceneGraphNode] { return [] }
    
    public var childCount: Int { return children.count }
    
    public var isLeaf: Bool { return children.isEmpty }
    
    public var category: SceneGraphNodeCategory { .actors }
    
    public var type: SceneGraphNodeType { return .grid }
}

extension NPCs: Updatable {
    
    func update(delta: TimeInterval, time: TimeInterval) {
        
        //
    }
}
