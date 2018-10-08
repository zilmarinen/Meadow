//
//  Blueprint.swift
//  Meadow-iOS
//
//  Created by Zack Brown on 28/09/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import SceneKit

public class Blueprint: SCNNode, SceneGraphChild {
    
    public override init() {
        
        super.init()
        
        self.name = "Blueprint"
    }
    
    public required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
}

extension Blueprint {
    
}
