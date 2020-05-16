//
//  SceneGraphIdentifiable.swift
//  Meadow
//
//  Created by Zack Brown on 27/04/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

public protocol SceneGraphIdentifiable: SceneGraphNode {
    
    var category: SceneGraphNodeCategory { get }
    
    var type: SceneGraphNodeType { get }
}
