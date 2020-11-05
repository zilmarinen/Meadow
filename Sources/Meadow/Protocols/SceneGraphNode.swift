//
//  SceneGraphNode.swift
//
//  Created by Zack Brown on 03/11/2020.
//

import Foundation

@objc public protocol SceneGraphNode: class {
    
    var name: String? { get }
    
    var category: Int { get }
    
    var children: [SceneGraphNode] { get }
    
    var childCount: Int { get }
    
    var isLeaf: Bool { get }
}
