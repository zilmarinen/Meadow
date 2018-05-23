//
//  SceneGraphNode.swift
//  Meadow-iOS
//
//  Created by Zack Brown on 14/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

/*!
 @protocol SceneGraphNode
 @abstract
 */
public protocol SceneGraphNode {
    
    /*!
     @property nodeName
     @abstract Returns the name of the SceneGraphNode.
     */
    var nodeName: String { get }
    
    /*!
     @property totalChildren
     @abstract Returns the total number of child SceneGraphNodes for the SceneGraphNode.
     */
    var totalChildren: Int { get }
    
    /*!
     @method sceneGraph:childAtIndex
     @abstract Attempt to find and return a child SceneGraphNode at the specified index.
     @property index The index of the child SceneGraphNode to be found and returned.
     */
    func sceneGraph(childAtIndex index: Int) -> SceneGraphNode?
}
