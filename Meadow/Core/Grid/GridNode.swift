//
//  GridNode.swift
//  Meadow
//
//  Created by Zack Brown on 26/04/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import SceneKit

/*!
 @class GridNode
 @abstract Grid nodes are the base class and fundamental building blocks of a grid.
 @discussion Grid nodes define a fixed volume which they occupy within a grid. This provides a bear bones implementation and any additional functionality should be added by subclassing.
 */
public class GridNode: SceneGraphNode {
    
    /*!
     @struct GridNodeNeighbour
     @abstract Defines a relationship between two grid nodes along an edge.
     */
    public struct GridNodeNeighbour: Hashable {
        
        let edge: GridEdge
        let node: GridNode
    }
    
    /*!
     @property isDirty
     @abstract Represents staleness of the node.
     */
    private var isDirty: Bool = false
    
    /*!
     @property delegate
     @abstract Delegate to inform when the node become dirty.
     */
    private let delegate: GridDelegate

    /*!
     @property volume
     @abstract Fixed bounding volume of the node.
     */
    let volume: Volume
    
    /*!
     @property mesh
     @abstract Returns the mesh of the node.
     */
    var mesh: Mesh { return Mesh(faces: [], triangles: []) }
    
    /*!
     @property nodeName
     @abstract Returns the name of the SceneGraphNode.
     */
    public var nodeName: String { return "Node" }
    
    /*!
     @property totalChildren
     @abstract Returns the total number of child SceneGraphNodes for the SceneGraphNode.
     */
    public var totalChildren: Int { return 0 }
    
    /*!
     @method init:volume
     @abstract Creates and initialises a node with the specified delegate and volume.
     @param delegate The delegate to call out to when node becomes dirty.
     @param volume The bounding volume occupied by the node.
     */
    public required init(delegate: GridDelegate, volume: Volume) {
        
        self.delegate = delegate
        
        self.volume = volume
    }
    
    /*!
     @method sceneGraph:childAtIndex
     @abstract Attempt to find and return a child SceneGraphNode at the specified index.
     @property index The index of the child SceneGraphNode to be found and returned.
     */
    public func sceneGraph(childAtIndex index: Int) -> SceneGraphNode? {
        
        return nil
    }
}

extension GridNode: Hashable {
    
    /*!
     @method ==
     @abstract Determine the equality of two GridNodes.
     */
    public static func == (lhs: GridNode, rhs: GridNode) -> Bool {
        
        return lhs.volume == rhs.volume
    }
    
    /*!
     @property hashValue
     @abstract Return the has value of the GridNode.
     */
    public var hashValue: Int {
        
        return volume.hashValue
    }
}

extension GridNode {
    
    /*!
     @method becomeDirty
     @abstract If not already true, toggle the isDirty flag to true.
     */
    func becomeDirty() {
        
        if isDirty { return }
        
        isDirty = true
        
        delegate.didBecomeDirty(node: self)
    }
}
