//
//  Grid.swift
//  Meadow
//
//  Created by Zack Brown on 26/04/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import SceneKit

public protocol GridDelegate {
    
    func didBecomeDirty(node: GridNode)
}

public class Grid<Chunk: GridChunk<Tile, Node>, Tile: GridTile<Node>, Node: GridNode>: SCNNode {
    
    private var isDirty: Bool = false
    
    private let delegate: GridDelegate
    
    public required init(delegate: GridDelegate) {
        
        self.delegate = delegate
        
        super.init()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
}

extension Grid {
    
    func becomeDirty() {
        
        if isDirty { return }
        
        isDirty = true
    }
    
    func clean() {
        
        if !isDirty { return }
            
        chunks.forEach { chunk in
            
            chunk.clean()
        }
        
        isDirty = false
    }
}

extension Grid: GridNodeDelegate {
    
    public func didBecomeDirty(node: GridNode) {
        
        if let chunk = find(chunk: node.volume.coordinate) {
            
            chunk.becomeDirty()
            
            becomeDirty()
            
            delegate.didBecomeDirty(node: node)
        }
    }
}

extension Grid {
    
    private var chunks: [Chunk] {
        
        return childNodes as! [Chunk]
    }
    
    public func add(node volume: Volume) -> Node? {
        
        if let _ = find(node: volume.coordinate) {
        
            return nil
        }
        
        let x = Int(Double(volume.coordinate.x) / Double(World.ChunkSize)) * World.ChunkSize
        let z = Int(Double(volume.coordinate.z) / Double(World.ChunkSize)) * World.ChunkSize
        
        let chunkCoordinate = Coordinate(x: x, y: World.Floor, z: z)
        let tileCoordinate = Coordinate(x: volume.coordinate.x, y: World.Floor, z: volume.coordinate.z)
        
        let chunkSize = Size(width: World.ChunkSize, height: (World.Ceiling - World.Floor), depth: World.ChunkSize)
        let tileSize = Size(width: World.TileSize, height: (World.Ceiling - World.Floor), depth: World.TileSize)
        
        let chunk = find(chunk: chunkCoordinate) ?? Chunk(volume: Volume(coordinate: chunkCoordinate, size: chunkSize))
        let tile = find(tile: tileCoordinate) ?? Tile(volume: Volume(coordinate: tileCoordinate, size: tileSize))
        let node = Node(delegate: self, volume: volume)
        
        if chunk.parent == nil {
            
            addChildNode(chunk)
        }
        
        chunk.add(tile: tile)
        
        tile.add(node: node)
        
        node.becomeDirty()
        
        return node
    }
    
    func remove(chunk coordinate: Coordinate) {
        
        if let chunk = find(chunk: coordinate) {
            
            chunk.removeFromParentNode()
            
            becomeDirty()
        }
    }
    
    func remove(tile coordinate: Coordinate) {
        
        if let chunk = find(chunk: coordinate), let tile = chunk.find(tile: coordinate) {
            
            chunk.remove(tile: tile)
            
            if chunk.isEmpty {
                
                chunk.removeFromParentNode()
            }
            
            becomeDirty()
        }
    }
    
    func remove(node coordinate: Coordinate) {
        
        if let chunk = find(chunk: coordinate), let tile = chunk.find(tile: coordinate), let node = tile.find(node: coordinate) {
            
            tile.remove(node: node)
            
            if tile.isEmpty {
                
                chunk.remove(tile: tile)
                
                if chunk.isEmpty {
                    
                    chunk.removeFromParentNode()
                }
            }
            
            chunk.becomeDirty()
            
            becomeDirty()
        }
    }
    
    func find(chunk coordinate: Coordinate) -> Chunk? {
     
        return chunks.first { chunk -> Bool in
            
            return chunk.volume.contains(coordinate: coordinate)
        }
    }
    
    func find(tile coordinate: Coordinate) -> Tile? {
        
        if let chunk = find(chunk: coordinate), let tile = chunk.find(tile: coordinate) {
            
            return tile
        }
        
        return nil
    }
    
    func find(node coordinate: Coordinate) -> Node? {
        
        if let tile = find(tile: coordinate), let node = tile.find(node: coordinate) {
            
            return node
        }
        
        return nil
    }
}
