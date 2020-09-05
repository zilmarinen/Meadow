//
//  SceneGraphIdentifiable.swift
//  Meadow
//
//  Created by Zack Brown on 27/04/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

import Terrace

public protocol SceneGraphIdentifiable: SceneGraphNode, StartOption {
    
    var category: SceneGraphNodeCategory { get }
    
    var type: SceneGraphNodeType { get }
}
