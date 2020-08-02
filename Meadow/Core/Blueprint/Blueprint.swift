//
//  Blueprint.swift
//  Meadow
//
//  Created by Zack Brown on 31/07/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

import SceneKit

public class Blueprint: SCNNode {
    
    public weak var graph: Graph?
    
    init(graph: Graph) {
        
        self.graph = graph
        
        super.init()
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    func clear() {
        
        self.geometry = nil
    }
}
