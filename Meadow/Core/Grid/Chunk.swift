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

public class Chunk<T: Tile>: SCNNode, Hideable, SceneGraphIdentifiable, SceneGraphNode, Soilable {
    
    public weak var ancestor: SoilableParent?
    
    public var coordinate: Coordinate { return volume.coordinate }
    
    public var isDirty = false
    
    let volume: Volume
    
    var tiles: [T] = []
    
    public override var isHidden: Bool {
        
        didSet {
            
            becomeDirty()
        }
    }
    
    required init(ancestor: SoilableParent, coordinate: Coordinate) {
        
        self.ancestor = ancestor
        
        self.volume = World.Axis.aligned(chunk: coordinate)
        
        super.init()
        
        self.name = "Chunk [\(volume.coordinate.x), \(volume.coordinate.y), \(volume.coordinate.z)]"
        
        self.position = SCNVector3(coordinate: Coordinate(x: volume.coordinate.x, y: 0, z: volume.coordinate.z))
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    public var children: [SceneGraphNode] { return tiles }
    
    public var childCount: Int { return children.count }
    
    public var isLeaf: Bool { return children.isEmpty }
    
    public var category: SceneGraphNodeCategory { fatalError("Chunk.category must be overridden") }
    
    public var type: SceneGraphNodeType { return .chunk }
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
    
    @discardableResult public func clean() -> Bool {
        
        guard isDirty else { return false }
        
        var mesh = Mesh(polygons: [])
        
        tiles.forEach { tile in
            
            tile.clean()
            
            if !tile.isHidden {
                
                mesh = mesh.union(mesh: tile.mesh)
            }
        }
        
        geometry = SCNGeometry(mesh: mesh)
        
        let node = childNodes.first ?? SCNNode()
        
        if node.parent == nil {
            
            addChildNode(node)
        }
        
        node.geometry = SCNGeometry(normals: mesh)
        
        if let shadable = self as? Shadable {
            
            geometry?.program = shadable.shader
            
            if let uniform = shadable.uniform {
                
                geometry?.set(uniform: uniform)
            }
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
        
        case tiles
    }
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(tiles, forKey: .tiles)
    }
}

extension Chunk: Updatable {
    
    func update(delta: TimeInterval, time: TimeInterval) {
        
        tiles.forEach { tile in
            
            tile.update(delta: delta, time: time)
        }
    }
}
