//
//  Chunk.swift
//  Meadow
//
//  Created by Zack Brown on 07/02/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

import Foundation
import SceneKit
import Pasture

class Chunk<T: Tile>: SCNNode, Renderable, Soilable {
    
    internal weak var ancestor: SoilableParent?
    
    internal var isDirty = false
    
    let volume: Volume
    
    var tiles: [T] = []
    
    required init(ancestor: SoilableParent, coordinate: Coordinate) {
        
        self.ancestor = ancestor
        
        self.volume = World.Axis.aligned(chunk: coordinate)
        
        super.init()
        
        self.position = SCNVector3(vector: World.Axis.convert(coordinate: volume.coordinate))
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
}

extension Chunk {
    
    func find(tile coordinate: Coordinate) -> T? {
        
        return tiles.first { tile in
            
            return tile.volume.coordinate.adjacency(to: coordinate) == .equal
        }
    }
    
    func add(tile coordinate: Coordinate) -> T {
        
        if let tile = find(tile: coordinate) { return tile }
        
        let tile = T(ancestor: self, coordinate: coordinate)
        
        tiles.append(tile)
        
        becomeDirty()
        
        return tile
    }
    
    func remove(tile coordinate: Coordinate) {
        
        guard let tile = find(tile: coordinate), let index = tiles.firstIndex(of: tile) else { return }
        
        tiles.remove(at: index)
        
        becomeDirty()
    }
}

extension Chunk {
    
    @discardableResult func clean() -> Bool {
        
        guard isDirty else { return false }
        
        tiles.forEach { tile in
            
            tile.clean()
            
            let node = SCNNode()
            
            node.position = SCNVector3(vector: World.Axis.convert(coordinate: tile.volume.coordinate) - Vector(vector: position))
            node.geometry = SCNBox(width: 1, height: 1, length: 1, chamferRadius: 0)
            
            addChildNode(node)
        }
        
        isDirty = false
        
        return true
    }
}

extension Chunk: Clearable {
    
    func clear() {
        
        while(tiles.count > 0) {
            
            let tile = tiles.removeLast()
            
            tile.clear()
        }
    }
}

extension Chunk: Encodable {
    
    enum CodingKeys: CodingKey {
        
        case name
        case tiles
    }
    
    func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(name, forKey: .name)
        try container.encode(tiles, forKey: .tiles)
    }
}

extension Chunk: Updatable {
    
    func update(delta: TimeInterval, time: TimeInterval) {
        
        tiles.forEach { tile in
            
            tile.update(delta: delta, time: time)
        }
        
        clean()
    }
}
