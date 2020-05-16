//
//  SceneGraphNode.swift
//  Meadow
//
//  Created by Zack Brown on 23/04/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

@objc public protocol SceneGraphNode: class {
    
    var name: String? { get }
    
    var children: [SceneGraphNode] { get }
    
    var childCount: Int { get }
    
    var isLeaf: Bool { get }
}
