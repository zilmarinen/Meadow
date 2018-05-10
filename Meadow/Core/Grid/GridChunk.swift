//
//  GridChunk.swift
//  Meadow
//
//  Created by Zack Brown on 26/04/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import SceneKit

/*!
 @class GridChunk
 @abstract Grid chunks are the parent class for all grid tiles and nodes.
 @discussion Grid chunks allow tiles and nodes to be partitioned into smaller, more managable entities which can be updated separately from other chunks, tiles and nodes in the same grid. Chunks have a fixed volume and are anchored to the grid along the x and z axis with a fixed height defined by `World.Floor` and `World.Ceiling`.
 */
public class GridChunk<Tile: GridTile<Node>, Node: GridNode>: SCNNode {
    
    private var isDirty: Bool = false
    
    private var tiles: Set<Tile> = []

    let volume: Volume
    
    var isEmpty: Bool { return tiles.isEmpty }
    
    public required init(volume: Volume) {
        
        self.volume = volume
        
        super.init()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
}

extension GridChunk {
    
    static func FixedVolume(_ coordinate: Coordinate) -> Volume {
        
        let x = Int(floor(Double(coordinate.x) / Double(World.ChunkSize))) * World.ChunkSize
        let z = Int(floor(Double(coordinate.z) / Double(World.ChunkSize))) * World.ChunkSize
        
        let coordinate = Coordinate(x: x, y: World.Floor, z: z)
        let size = Size(width: World.ChunkSize, height: (World.Ceiling - World.Floor), depth: World.ChunkSize)
        
        return Volume(coordinate: coordinate, size: size)
    }
}

extension GridChunk {
    
    func becomeDirty() {
        
        if isDirty { return }
        
        isDirty = true
    }
    
    func clean() {
        
        if !isDirty { return }
        
        if let tile = tiles.first {
        
            geometry = tile.geometry
        }
        
        isDirty = false
    }
}

extension GridChunk {
    
    func add(tile: Tile) {
        
        if let _ = find(tile: tile.volume.coordinate) {
            
            return
        }
        
        tiles.insert(tile)
        
        becomeDirty()
    }
    
    func remove(tile: Tile) {
        
        if let _ = tiles.remove(tile) {
        
            becomeDirty()
        }
    }
    
    func find(tile coordinate: Coordinate) -> Tile? {
        
        return tiles.first { tile -> Bool in
            
            return tile.volume.coordinate.adjacency(to: coordinate) == .equal
        }
    }
}
