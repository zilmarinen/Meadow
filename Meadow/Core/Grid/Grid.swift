//
//  Grid.swift
//  Meadow
//
//  Created by Zack Brown on 26/04/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import SceneKit

public class Grid<Chunk: GridChunk<Tile, Node>, Tile: GridTile<Node>, Node: GridNode>: SCNNode, Encodable, SceneGraphChild, SceneGraphObserver, SceneGraphParent {
    
    var children = Tree<Chunk>()
    
    public var observer: SceneGraphObserver?
    
    var isDirty: Bool = false
    
    public var volume: Volume {
        
        return Volume(coordinate: Coordinate.zero, size: Size.one)
    }
    
    enum CodingKeys: CodingKey {
        
        case name
        case children
    }
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(self.name, forKey: .name)
        try container.encode(self.children.children, forKey: .children)
    }
    
    public override func addChildNode(_ child: SCNNode) {
        
        guard let child = child as? Chunk else { return }
        
        if children.append(child) {
            
            super.addChildNode(child)
        }
    }
}

extension Grid {
    
    public var totalChildren: Int { return children.count }
    
    public func child(at index: Int) -> SceneGraphChild? {
        
        return children[index]
    }
    
    public func index(of child: SceneGraphChild) -> Int? {
        
        guard let child = child as? Chunk else { return nil }
        
        return children.index(of: child)
    }
}

extension Grid: SceneGraphSoilable {
    
    @discardableResult public func becomeDirty() -> Bool {
        
        if !isDirty {
            
            isDirty = true
            
            observer?.child(didBecomeDirty: self)
        }
        
        return isDirty
    }
    
    @discardableResult public func clean() -> Bool {
        
        if !isDirty { return false }
        
        children.forEach { chunk in
            
            chunk.clean()
        }
        
        isDirty = false
        
        return true
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
    
    public func child(didBecomeDirty child: SceneGraphChild) {
        
        becomeDirty()
        
        observer?.child(didBecomeDirty: child)
    }
}

extension Grid {
    
    func add(node volume: Volume) -> Node? {
        
        if volume.coordinate.y < World.floor || (volume.coordinate.y + volume.size.height) > World.ceiling {
            
            return nil
        }
        
        if find(node: volume.coordinate) != nil {
            
            return nil
        }
        
        let chunk = find(chunk: volume.coordinate) ?? Chunk(observer: self, volume: Chunk.fixedVolume(volume.coordinate))
        
        let tile = chunk.find(tile: volume.coordinate) ?? chunk.add(tile: Tile.fixedVolume(volume.coordinate))
        
        guard let node = tile?.add(node: volume) else { return nil }
        
        if chunk.parent == nil {
            
            addChildNode(chunk)
            
            chunk.categoryBitMask = categoryBitMask
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
    
    @discardableResult public func remove(chunk: Chunk) -> Bool {
        
        if index(of: chunk) != nil {
            
            chunk.removeFromParentNode()
            
            chunk.observer = nil
            
            while let tile = chunk.children.first {
                
                chunk.remove(tile: tile)
            }
            
            children.remove(chunk)
            
            becomeDirty()
            
            return true
        }
        
        return false
    }
    
    @discardableResult public func remove(tile: Tile) -> Bool {
        
        if let chunk = find(chunk: tile.volume.coordinate) {
            
            if chunk.remove(tile: tile) {
                
                while let node = tile.children.first {
                    
                    tile.remove(node: node)
                }
                
                if chunk.totalChildren == 0 {
                    
                    remove(chunk: chunk)
                }
                
                return true
            }
        }
        
        return false
    }
    
    @discardableResult public func remove(node: Node) -> Bool {
        
        if let tile = find(tile: node.volume.coordinate) {
            
            if tile.remove(node: node) {
                
                GridEdge.Edges.forEach { edge in
                 
                    node.remove(neighbour: edge)
                }
                
                if tile.totalChildren == 0 {
                    
                    remove(tile: tile)
                }
                
                return true
            }
        }
        
        return false
    }
}
