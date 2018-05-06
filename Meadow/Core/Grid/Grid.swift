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
    
    private let delegate: GridDelegate
    
    private var isDirty: Bool = false
    
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
    
    func add(node volume: Volume) -> Node? {
        
        if let _ = find(node: volume.coordinate) {
        
            return nil
        }
        
        let chunk = find(chunk: volume.coordinate) ?? Chunk(volume: Chunk.FixedVolume(volume.coordinate))
        
        let tile = find(tile: volume.coordinate) ?? Tile(volume: Tile.FixedVolume(volume.coordinate))
        
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
