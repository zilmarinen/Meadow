 //
//  Grid.swift
//  Meadow
//
//  Created by Zack Brown on 26/04/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import SceneKit

public class Grid<Chunk: GridChunk<Tile, Node>, Tile: GridTile<Node>, Node: GridNode>: SCNNode, SceneGraphChild, GridParent {
    
    public typealias ChildType = Chunk
    
    public var children: [Chunk] { return childNodes as! [Chunk] }
    
    var isDirty: Bool = false
    
    var observer: GridObserver?
}

extension Grid: GridSoilable {
    
    public func becomeDirty() {
        
        if !isDirty {
            
            isDirty = true
        }
    }
    
    public func clean() {
        
        if !isDirty { return }
        
        children.forEach { chunk in
            
            chunk.clean()
        }
        
        isDirty = false
    }
}

extension Grid: SceneGraphUpdatable {
    
    public func update(deltaTime: TimeInterval) {
        
        clean()
        
        children.forEach { chunk in
            
            chunk.update(deltaTime: deltaTime)
        }
    }
}

extension Grid {
    
    public var totalChildren: Int { return childNodes.count }
    
    public func child(at index: Int) -> SceneGraphChild? {
        
        return childNodes[index] as? SceneGraphChild
    }
    
    public func index(of child: SceneGraphChild) -> Int? {
        
        guard let child = child as? ChildType else { return nil }
        
        return childNodes.index(of: child)
    }
    
    public func child(didBecomeDirty child: SceneGraphChild) {
        
        let _ = becomeDirty()
        
        observer?.child(didBecomeDirty: child)
    }
}

extension Grid {
    
    func add(node volume: Volume) -> Node? {
        
        if volume.coordinate.y < World.floor || (volume.coordinate.y + volume.size.height) > World.ceiling {
            
            return nil
        }
        
        if let _ = find(node: volume.coordinate) {
            
            return nil
        }
        
        let chunk = find(chunk: volume.coordinate) ?? Chunk(observer: self, volume: Chunk.fixedVolume(volume.coordinate))
        
        let tile = chunk.find(tile: volume.coordinate) ?? chunk.add(tile: Tile.fixedVolume(volume.coordinate))
        
        guard let node = tile?.add(node: volume) else { return nil }
        
        if chunk.parent == nil {
            
            addChildNode(chunk)
            
            chunk.categoryBitMask = categoryBitMask
            
            becomeDirty()
        }
        
        return node
    }
    
    public func find(chunk coordinate: Coordinate) -> Chunk? {
        
        return children.first { chunk -> Bool in
            
            return chunk.volume.contains(coordinate: coordinate)
        }
    }
    
    public func find(tile coordinate: Coordinate) -> Tile? {
        
        if let chunk = find(chunk: coordinate), let tile = chunk.find(tile: coordinate) {
            
            return tile
        }
        
        return nil
    }
    
    public func find(node coordinate: Coordinate) -> Node? {
        
        if let tile = find(tile: coordinate), let node = tile.find(node: coordinate) {
            
            return node
        }
        
        return nil
    }
    
    public func remove(chunk: Chunk) -> Bool {
        
        if let _ = index(of: chunk) {
            
            chunk.removeFromParentNode()
            
            chunk.observer = nil
            
            while chunk.totalChildren > 0 {
                
                let _ = chunk.remove(tile: chunk.child(at: 0) as! Tile)
            }
            
            becomeDirty()
            
            return true
        }
        
        return false
    }
    
    public func remove(tile: Tile) -> Bool {
        
        if let chunk = find(chunk: tile.volume.coordinate) {
            
            if chunk.remove(tile: tile) {
                
                while tile.totalChildren > 0 {
                    
                    let _ = tile.remove(node: tile.child(at: 0) as! Node)
                }
                
                if chunk.totalChildren == 0 {
                    
                    let _ = remove(chunk: chunk)
                }
                
                return true
            }
        }
        
        return false
    }
    
    public func remove(node: Node) -> Bool {
        
        if let tile = find(tile: node.volume.coordinate) {
            
            if tile.remove(node: node) {
                
                GridEdge.Edges.forEach { edge in
                 
                    let _ = node.remove(neighbour: edge)
                }
                
                if tile.totalChildren == 0 {
                    
                    let _ = remove(tile: tile)
                }
                
                return true
            }
        }
        
        return false
    }
}

extension Grid: Encodable {
    
    enum CodingKeys: CodingKey {
        
        case name
        case children
    }
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(self.name, forKey: .name)
        try container.encode(self.children, forKey: .children)
    }
}
