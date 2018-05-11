//
//  GridTile.swift
//  Meadow
//
//  Created by Zack Brown on 26/04/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import SceneKit

/*!
 @class GridTile
 @abstract Grid tiles are the parent class for any child nodes.
 @discussion Grid tiles allow nodes to be partitioned into smaller, more managable entities which can be updated separately from other tiles and nodes in the same grid. Tiles have a fixed volume with a height defined by `World.Floor` and `World.Ceiling`.
 */
public class GridTile<Node: GridNode> {
    
    /*!
     @struct GridTileNeighbour
     @abstract Defines a relationship between two grid tiles along an edge.
     */
    public struct GridTileNeighbour: Hashable {
        
        let edge: GridEdge
        let tile: GridTile
    }
    
    /*!
     @property nodes
     @abstract Set of nodes contained within the tile.
     */
    private var nodes: Set<Node> = []
    
    /*!
     @property volume
     @abstract Fixed bounding volume of the tile.
     */
    let volume: Volume
    
    /*!
     @property isEmpty
     @abstract Determines whether the tile has any child nodes.
     */
    var isEmpty: Bool { return nodes.isEmpty }
    
    /*!
     @property geometry
     @abstract Returns the geometry of the tiles child nodes.
     */
    var geometry: SCNGeometry { return SCNBox(width: CGFloat(volume.size.width), height: CGFloat(volume.size.height), length: CGFloat(volume.size.depth), chamferRadius: 1.0) }
    
    /*!
     @method init:volume
     @abstract Creates and initialises a tile with the specified volume.
     @param volume The bounding volume occupied by the tile.
     */
    public required init(volume: Volume) {
        
        self.volume = volume
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
     @abstract Return the has value of the GridTile.
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
