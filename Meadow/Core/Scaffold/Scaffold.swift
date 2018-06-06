//
//  Scaffold.swift
//  Meadow
//
//  Created by Zack Brown on 01/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Foundation

/*!
 @class Scaffold
 @abstract Scaffold is a Grid type that manages the addition and removal of ScaffoldNodes.
 */
public class Scaffold: Grid<ScaffoldChunk, ScaffoldTile, ScaffoldNode> {
 
    /*!
     @property nodeName
     @abstract Returns the name of the SceneGraphNode.
     */
    override public var nodeName: String { return "Scaffolds" }
}
