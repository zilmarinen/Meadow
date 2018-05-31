//
//  GridNode.swift
//  Meadow
//
//  Created by Zack Brown on 26/04/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import SceneKit

/*!
 @class GridNodeJSON
 @abstract
 */
public class GridNodeJSON: Decodable {
    
    /*!
     @property volume
     @abstract Fixed bounding volume of the node.
     */
    let volume: Volume = Volume(coordinate: Coordinate.Zero, size: Size.Zero)
}

/*!
 @class GridNode
 @abstract Grid nodes are the base class and fundamental building blocks of a grid.
 @discussion Grid nodes define a fixed volume which they occupy within a grid. This provides a bear bones implementation and any additional functionality should be added by subclassing.
 */
public class GridNode: SceneGraphNode, Encodable {
    
    /*!
     @struct GridNodeNeighbour
     @abstract Defines a relationship between two grid nodes along an edge.
     */
    public struct GridNodeNeighbour: Hashable {
        
        /*!
         @property edge
         @abstract The shared edge between the two nodes.
         */
        let edge: GridEdge
        
        /*!
         @property node
         @abstract The opposite node along the edge.
         */
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
     @property isHidden
     @abstract Determines whether the node is displayed
     */
    public var isHidden: Bool = false {
        
        didSet {
            
            becomeDirty()
        }
    }

    /*!
     @property volume
     @abstract Fixed bounding volume of the node.
     */
    public let volume: Volume
    
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
    public func sceneGraph(childAtIndex index: Int) -> SceneGraphNode? { return nil }
    
    /*!
     @method sceneGraph:indexOf
     @abstract Attempt to find and return the index of the specified child.
     @param child The child for which the index should be found and returned.
     */
    public func sceneGraph(indexOf child: SceneGraphNode) -> Int? { return nil }
    
    /*!
     @enum CodingKeys
     @abstract Defines the coding keys used when encoding this object.
     */
    private enum CodingKeys: CodingKey {
        
        case volume
    }
    
    /*!
     @method encode:to
     @abstract Encodes this object into the given encoder.
     @property encoder The encoder to use when encoding this object.
     */
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(volume, forKey: .volume)
    }
    
    /*!
     @method compactMesh
     @abstract Returns the compound mesh of the node.
     */
    func compactMesh() -> Mesh {
        
        return Mesh(faces: [], triangles: [])
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
     @abstract Return the hash value of the GridNode.
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
    
    /*!
     @method clean
     @abstract Enumerate through children and clean each chunk.
     */
    func clean() {
        
        if !isDirty { return }
        
        isDirty = false
    }
}
