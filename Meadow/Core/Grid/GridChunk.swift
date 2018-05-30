//
//  GridChunk.swift
//  Meadow
//
//  Created by Zack Brown on 26/04/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import SceneKit

/*!
 @struct GridChunkJSON
 @abstract
 */
public struct GridChunkJSON<NodeJSON: GridNodeJSON>: Decodable {
    
    /*!
     @property tiles
     @abstract Set of tiles contained within the chunk.
     */
    let tiles: [GridTileJSON<NodeJSON>]
}

/*!
 @class GridChunk
 @abstract Grid chunks are the parent class for all grid tiles and nodes.
 @discussion Grid chunks allow tiles and nodes to be partitioned into smaller, more managable entities which can be updated separately from other chunks, tiles and nodes in the same grid. Chunks have a fixed volume and are anchored to the grid along the x and z axis with a fixed height defined by `World.Floor` and `World.Ceiling`.
 */
public class GridChunk<Tile: GridTile<Node>, Node: GridNode>: SCNNode, SceneGraphNode, Encodable {
    
    /*!
     @property isDirty
     @abstract Represents staleness of the chunk.
     */
    private var isDirty: Bool = false
    
    /*!
     @property tiles
     @abstract Set of tiles contained within the chunk.
     */
    private var tiles: Set<Tile> = []
    
    /*!
     @property sortedTiles
     @abstract Array of tiles, sorted by coordinate x and z axis values.
     */
    private var sortedTiles: [Tile] {
        
        return tiles.sorted { (lhs, rhs) -> Bool in
            
            return lhs.volume.coordinate.x < rhs.volume.coordinate.x && lhs.volume.coordinate.z < rhs.volume.coordinate.z
        }
    }

    /*!
     @property volume
     @abstract Fixed bounding volume of the chunk.
     */
    public let volume: Volume
    
    /*!
     @property isEmpty
     @abstract Determines whether the chunk has any child tiles.
     */
    var isEmpty: Bool { return tiles.isEmpty }
    
    /*!
     @property nodeName
     @abstract Returns the name of the SceneGraphNode.
     */
    public var nodeName: String { return "Chunk" }
    
    /*!
     @property totalChildren
     @abstract Returns the total number of child SceneGraphNodes for the SceneGraphNode.
     */
    public var totalChildren: Int { return tiles.count }
    
    /*!
     @method init:volume
     @abstract Creates and initialises a chunk with the specified volume.
     @param volume The bounding volume occupied by the chunk.
     */
    public required init(volume: Volume) {
        
        self.volume = volume
        
        super.init()
    }
    
    /*!
     @method initWithCoder
     @abstract Support coding and decoding via NSKeyedArchiver.
     */
    public required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    /*!
     @method sceneGraph:childAtIndex
     @abstract Attempt to find and return a child SceneGraphNode at the specified index.
     @property index The index of the child SceneGraphNode to be found and returned.
     */
    public func sceneGraph(childAtIndex index: Int) -> SceneGraphNode? {
        
        return sortedTiles[index]
    }
    
    /*!
     @method sceneGraph:indexOf
     @abstract Attempt to find and return the index of the specified child.
     @param child The child for which the index should be found and returned.
     */
    public func sceneGraph(indexOf child: SceneGraphNode) -> Int? {
        
        guard let child = child as? Tile else { return nil }
        
        return sortedTiles.index(of: child)
    }
    
    /*!
     @enum CodingKeys
     @abstract Defines the coding keys used when encoding this object.
     */
    private enum CodingKeys: CodingKey {
        
        case tiles
    }
    
    /*!
     @method encode:to
     @abstract Encodes this object into the given encoder.
     @property encoder The encoder to use when encoding this object.
     */
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(tiles, forKey: .tiles)
    }
}

extension GridChunk {
    
    /*!
     @method FixedVolume:coordinate
     @abstract Clamp and return a fixed volume for a given coordinate.
     @discussion This method will return a volume with a fixed height defined by `World.Floor` and `World.Ceiling` as well as a fixed width and depth defined by `World.ChunkSize`.
     */
    static func FixedVolume(_ coordinate: Coordinate) -> Volume {
        
        let x = Int(floor(Double(coordinate.x) / Double(World.ChunkSize))) * World.ChunkSize
        let z = Int(floor(Double(coordinate.z) / Double(World.ChunkSize))) * World.ChunkSize
        
        let coordinate = Coordinate(x: x, y: World.Floor, z: z)
        let size = Size(width: World.ChunkSize, height: (World.Ceiling - World.Floor), depth: World.ChunkSize)
        
        return Volume(coordinate: coordinate, size: size)
    }
}

extension GridChunk {
    
    /*!
     @method becomeDirty
     @abstract If not already true, toggle the isDirty flag to true.
     */
    func becomeDirty() {
        
        if isDirty { return }
        
        isDirty = true
    }
    
    /*!
     @method clean
     @abstract Loop through children and clean each tile.
     */
    func clean() {
        
        if !isDirty { return }
        
        let meshes = tiles.compactMap { $0.compactMesh() }
        
        let mesh = Mesh(meshes: meshes)
        
        geometry = SCNGeometry(mesh: mesh)
        
        isDirty = false
    }
    
    /*!
     @method clear
     @abstract Removes all child Chunks, Tiles and Nodes.
     */
    func clear() {
        
        tiles.removeAll()
    }
}

extension GridChunk {
    
    /*!
     @method add:tile
     @abstract Attempt to add given tile to array of children.
     @param tile The tile to be added as a child.
     */
    func add(tile: Tile) {
        
        if let _ = find(tile: tile.volume.coordinate) {
            
            return
        }
        
        tiles.insert(tile)
        
        becomeDirty()
    }
    
    /*!
     @method remove:tile
     @abstract Attempt to remove given tile from array of children.
     @param tile The tile to be removed as a child.
     */
    func remove(tile: Tile) {
        
        if let _ = tiles.remove(tile) {
        
            becomeDirty()
        }
    }
    
    /*!
     @method find:tile
     @abstract Attempt to find and return the appropriate tile at the specified coordinate
     @param coordinate: Coordinate of the tile to be found and returned.
     @discussion The coordinate provided will be used to find the tile matching both the x and z axis irrelevant of the y axis value.
     */
    func find(tile coordinate: Coordinate) -> Tile? {
        
        return tiles.first { tile -> Bool in
            
            return tile.volume.coordinate.adjacency(to: coordinate) == .equal
        }
    }
}
