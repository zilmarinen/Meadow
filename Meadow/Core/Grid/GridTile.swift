//
//  GridTile.swift
//  Meadow
//
//  Created by Zack Brown on 26/04/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import SceneKit

/*!
 @struct GridTileJSON
 @abstract
 */
public struct GridTileJSON<NodeJSON: GridNodeJSON>: Decodable {
    
    /*!
     @enum CodingKeys
     @abstract Defines the coding keys used when encoding this object.
     */
    private enum CodingKeys: CodingKey {
        
        case nodes
    }
    
    /*!
     @property nodes
     @abstract Set of nodes contained within the tile.
     */
    let nodes: [NodeJSON]
}

/*!
 @class GridTile
 @abstract Grid tiles are the parent class for any child nodes.
 @discussion Grid tiles allow nodes to be partitioned into smaller, more managable entities which can be updated separately from other tiles and nodes in the same grid. Tiles have a fixed volume with a height defined by `World.Floor` and `World.Ceiling`.
 */
public class GridTile<Node: GridNode>: SceneGraphNode, Encodable {
    
    /*!
     @struct GridTileNeighbour
     @abstract Defines a relationship between two grid tiles along an edge.
     */
    public struct GridTileNeighbour: Hashable {
        
        let edge: GridEdge
        let tile: GridTile
    }
    
    /*!
     @property isDirty
     @abstract Represents staleness of the chunk.
     */
    private var isDirty: Bool = false
    
    /*!
     @property delegate
     @abstract The SoilableDelegate to inform when the tile becomes dirty.
     */
    private let delegate: SoilableDelegate
    
    /*!
     @property nodes
     @abstract Set of nodes contained within the tile.
     */
    private var nodes: Set<Node> = []
    
    /*!
     @property sortedNodes
     @abstract Array of nodes, sorted by y axis value.
     */
    private var sortedNodes: [Node] {
        
        return nodes.sorted { (lhs, rhs) -> Bool in
            
            return lhs.volume.coordinate.y < rhs.volume.coordinate.y
        }
    }
    
    /*!
     @property volume
     @abstract Fixed bounding volume of the tile.
     */
    public let volume: Volume
    
    /*!
     @property isEmpty
     @abstract Determines whether the tile has any child nodes.
     */
    var isEmpty: Bool { return nodes.isEmpty }
    
    /*!
     @property isHidden
     @abstract Determines whether the tile is displayed
     */
    public var isHidden: Bool = false {
        
        didSet {
            
            becomeDirty()
        }
    }
    
    /*!
     @property nodeName
     @abstract Returns the name of the SceneGraphNode.
     */
    public var nodeName: String { return "Tile" }
    
    /*!
     @property totalChildren
     @abstract Returns the total number of child SceneGraphNodes for the SceneGraphNode.
     */
    public var totalChildren: Int { return nodes.count }
    
    /*!
     @method init:volume
     @abstract Creates and initialises a tile with the specified volume.
     @param delegate The SoilableDelegate to inform when the tile becomes dirty.
     @param volume The bounding volume occupied by the tile.
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
    public func sceneGraph(childAtIndex index: Int) -> SceneGraphNode? {
        
        return sortedNodes[index]
    }
    
    /*!
     @method sceneGraph:indexOf
     @abstract Attempt to find and return the index of the specified child.
     @param child The child for which the index should be found and returned.
     */
    public func sceneGraph(indexOf child: SceneGraphNode) -> Int? {
        
        guard let child = child as? Node else { return nil }
        
        return sortedNodes.index(of: child)
    }
    
    /*!
     @enum CodingKeys
     @abstract Defines the coding keys used when encoding this object.
     */
    private enum CodingKeys: CodingKey {
        
        case nodes
    }
    
    /*!
     @method encode:to
     @abstract Encodes this object into the given encoder.
     @property encoder The encoder to use when encoding this object.
     */
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(nodes, forKey: .nodes)
    }
    
    /*!
     @method compactMesh
     @abstract Returns the compound mesh of the tiles child nodes.
     */
    func compactMesh() -> Mesh {
        
        let meshes = nodes.filter { !$0.isHidden }.compactMap { $0.compactMesh() }
        
        return Mesh(meshes: meshes)
    }
}

extension GridTile: Hashable {
    
    /*!
     @method ==
     @abstract Determine the equality of two GridTiles.
     */
    public static func == (lhs: GridTile<Node>, rhs: GridTile<Node>) -> Bool {
        
        return lhs.volume == rhs.volume
    }
    
    /*!
     @property hashValue
     @abstract Return the hash value of the GridTile.
     */
    public var hashValue: Int {
        
        return volume.hashValue
    }
}

extension GridTile {
    
    /*!
     @method FixedVolume:coordinate
     @abstract Clamp and return a fixed volume for a given coordinate.
     @discussion This method will return a volume with a fixed height defined by `World.Floor` and `World.Ceiling` as well as a fixed width and depth defined by `World.TileSize`.
     */
    static func FixedVolume(_ coordinate: Coordinate) -> Volume {
        
        let coordinate = Coordinate(x: coordinate.x, y: World.Floor, z: coordinate.z)
        let size = Size(width: World.TileSize, height: (World.Ceiling - World.Floor), depth: World.TileSize)
        
        return Volume(coordinate: coordinate, size: size)
    }
}

extension GridTile: SoilableDelegate {
    
    /*!
     @method didBecomeDirty:volume
     @abstract Callback for soilable item to delegate change resolution upwards.
     @param soilable The Soilable object that became dirty.
     */
    public func didBecomeDirty(soilable: Soilable) {
        
        delegate.didBecomeDirty(soilable: soilable)
        
        becomeDirty()
    }
}

extension GridTile: Soilable {
    
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
        
        if !isDirty { return false}
        
        nodes.forEach { node in
            
            let _ = node.clean()
        }
        
        isDirty = false
        
        return true
    }
}

extension GridTile {
    
    /*!
     @method add:node
     @abstract Attempt to add given node to array of children.
     @param node The node to be added as a child.
     */
    func add(node: Node) {
        
        if let _ = find(node: node.volume.coordinate) {
            
            return
        }
        
        nodes.insert(node)
    }
    
    /*!
     @method remove:node
     @abstract Attempt to remove given node from array of children.
     @param node The node to be removed as a child.
     */
    func remove(node: Node) {
        
        nodes.remove(node)
    }
    
    /*!
     @method find:node
     @abstract Attempt to find and return the appropriate node at the specified coordinate
     @param coordinate: Coordinate of the node to be found and returned.
     @discussion The coordinate provided will be used to find the nearest enclosing bounds matching both the x and z axis where the y axis value also intersects with the nodes bounds.
     */
    func find(node coordinate: Coordinate) -> Node? {
        
        return nodes.first { node -> Bool in
            
            return node.volume.contains(coordinate: coordinate)
        }
    }
}
