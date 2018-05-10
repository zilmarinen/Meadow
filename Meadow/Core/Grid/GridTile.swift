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
 @discussion Grid tiles allow nodes to be partitioned into smaller, more managable entities which can be updated separately from other tiles and nodes in the same grid. Tiles have a fixed volume with a fixed height defined by `World.Floor` and `World.Ceiling`.
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
    
    private var nodes: Set<Node> = []
    
    let volume: Volume
    
    var isEmpty: Bool { return nodes.isEmpty }
    
    var geometry: SCNGeometry { return SCNBox(width: CGFloat(volume.size.width), height: CGFloat(volume.size.height), length: CGFloat(volume.size.depth), chamferRadius: 1.0) }
    
    public required init(volume: Volume) {
        
        self.volume = volume
    }
}

extension GridTile: Hashable {
    
    public static func == (lhs: GridTile<Node>, rhs: GridTile<Node>) -> Bool {
        
        return lhs.volume == rhs.volume
    }
    
    public var hashValue: Int {
        
        return volume.hashValue
    }
}

extension GridTile {
    
    static func FixedVolume(_ coordinate: Coordinate) -> Volume {
        
        let coordinate = Coordinate(x: coordinate.x, y: World.Floor, z: coordinate.z)
        let size = Size(width: World.TileSize, height: (World.Ceiling - World.Floor), depth: World.TileSize)
        
        return Volume(coordinate: coordinate, size: size)
    }
}

extension GridTile {
    
    func add(node: Node) {
        
        if let _ = find(node: node.volume.coordinate) {
            
            return
        }
        
        nodes.insert(node)
    }
    
    func remove(node: Node) {
        
        nodes.remove(node)
    }
    
    func find(node coordinate: Coordinate) -> Node? {
        
        return nodes.first { node -> Bool in
            
            return node.volume.contains(coordinate: coordinate)
        }
    }
}
