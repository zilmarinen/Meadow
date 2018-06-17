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
public class GridNode: SceneGraphNode, Encodable, Soilable {
    
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
     @property neighbours
     @abstract An array of neighbouring grid nodes.
     */
    private var neighbours: Set<GridNodeNeighbour> = []
    
    /*!
     @property isDirty
     @abstract Represents staleness of the node.
     */
    internal var isDirty: Bool = false
    
    /*!
     @property delegate
     @abstract The SoilableDelegate to inform when the node becomes dirty.
     */
    private let delegate: SoilableDelegate
    
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
     @param delegate The SoilableDelegate to inform when the node becomes dirty.
     @param volume The bounding volume occupied by the node.
     */
    public required init(delegate: SoilableDelegate, volume: Volume) {
        
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
    public func compactMesh() -> Mesh {
        
        return Mesh(faces: [], triangles: [])
    }
    
    /*!
     @method becomeDirty
     @abstract Record that the item is dirty and should be cleaned.
     */
    public func becomeDirty() {
        
        if isDirty { return }
        
        isDirty = true
        
        delegate.didBecomeDirty(soilable: self)
    }
    
    /*!
     @method clean
     @abstract Perform any clean up operations required to clean the item.
     */
    public func clean() -> Bool {
        
        if !isDirty { return false }
        
        isDirty = false
        
        return true
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
     @method add:neighbour:edge
     @abstract Attempt to create a relationship between two nodes along the specified edge.
     @param neighbour The node to become neighbours with.
     @param edge The edge shared between the two nodes.
     */
    func add(neighbour node: GridNode, edge: GridEdge) {
        
        guard node.volume.coordinate.adjacency(to: volume.coordinate) == .adjacent else { return }
        
        remove(neighbour: edge)
        
        neighbours.insert(GridNodeNeighbour(edge: edge, node: node))
        
        let oppositeEdge = GridEdge.Opposite(edge: edge)
        
        if node.find(neighbour: oppositeEdge) == nil {
            
            node.add(neighbour: self, edge: oppositeEdge)
        }
        
        becomeDirty()
    }
    
    /*!
     @method remove:neighbour:edge
     @abstract Attempt to remove the relationship between two nodes along the specified edge.
     @param edge The edge shared between the two nodes.
     */
    func remove(neighbour edge: GridEdge) {
        
        guard let neighbour = find(neighbour: edge) else { return }
        
        neighbours.remove(neighbour)
        
        let oppositeEdge = GridEdge.Opposite(edge: edge)
        
        if let _ = neighbour.node.find(neighbour: oppositeEdge) {
            
            neighbour.node.remove(neighbour: oppositeEdge)
        }
        
        becomeDirty()
    }
    
    /*!
     @method find:neighbour:edge
     @abstract Attempt to find and return the neighbouring node along the specified edge.
     @param edge The GridEdge shared between the two nodes.
     */
    func find(neighbour edge: GridEdge) -> GridNodeNeighbour? {
        
        return neighbours.first { neighbour -> Bool in
            
            return neighbour.edge == edge
        }
    }
    
    /*!
     @method find:neighbour:corner
     @abstract Attempt to find and return the neighbouring node along the specified edge.
     @param edge The GridEdge shared between the two nodes.
     @param corner The GridCorner used to determine the diagonal corner shared between the two nodes.
     */
    func find(neighbour edge: GridEdge, corner: GridCorner) -> GridNodeNeighbour? {
        
        let connectedEdges = GridEdge.Edges(corner: corner)
        
        let e0 = connectedEdges.first!
        let e1 = connectedEdges.last!
        
        let a0 = find(neighbour: e0)?.node
        let a1 = find(neighbour: e1)?.node
        
        return (a0 != nil ? a0!.find(neighbour: e1) : (a1 != nil ? a1!.find(neighbour: e0) : nil))
    }
}
