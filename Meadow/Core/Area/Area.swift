//
//  Area.swift
//  Meadow
//
//  Created by Zack Brown on 01/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

/*!
 @class Area
 @abstract Area is a Grid type that manages the addition and removal of AreaNodes.
 */
public class Area: Grid<AreaChunk, AreaTile, AreaNode> {
    
    /*!
     @property nodeName
     @abstract Returns the name of the SceneGraphNode.
     */
    override public var nodeName: String { return "Areas" }
}
