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
    
    public struct Slice: Equatable {
        
        let segment: Int
        let radius: Int
        
        init(vector: Vector) {
            
            self.segment = World.Axis.segment(vector: vector)
            self.radius = World.Axis.radius(vector: vector)
        }
    }
    
    public weak var ancestor: SoilableParent?
    
    public var identifier: Int { return (slice.radius * (slice.segment + 1))}
    
    public var slice: Slice
    
    public var isDirty = false
    
    var tiles: [T] = []
    
    public override var isHidden: Bool {
        
        didSet {
            
            guard oldValue != isHidden else { return }
            
            becomeDirty()
        }
    }
    
    required init(ancestor: SoilableParent, slice: Slice) {
        
        self.ancestor = ancestor
        
        self.slice = slice
        
        super.init()
        
        self.name = "Chunk [\(slice.segment), \(slice.radius)]"
        
        self.categoryBitMask = category.rawValue
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
    
    func find(tile identifier: Int) -> T? {
        
        return tiles.first { tile in
            
            return tile.identifier == identifier
        }
    }
    
    func find(tile vector: Vector) -> T? {
        
        return tiles.first { tile in
            
            let polygon = Pasture.Polygon(vertices: tile.vectors.map { Vertex(position: $0, normal: .up) })
            
            return polygon.contains(vector: vector)
        }
    }
    
    func add(tile identifier: Int, joints: [Graph.Joint], vectors: [Vector]) -> T {
        
        if let tile = find(tile: identifier) { return tile }
        
        let tile = T(ancestor: self, identifier: identifier, joints: joints, vectors: vectors)
        
        tiles.append(tile)
        
        becomeDirty()
        
        return tile
    }
    
    func remove(tile identifier: Int) {
        
        guard let tile = find(tile: identifier), let index = tiles.firstIndex(of: tile) else { return }
        
        tiles.remove(at: index)
        
        becomeDirty()
    }
}

extension Chunk {
    
    @discardableResult public func clean() -> Bool {
        
        guard isDirty else { return false }
        
        var polygons: [Pasture.Polygon] = []
        
        tiles.forEach { tile in
            
            tile.clean()
            
            if !tile.isHidden {
                
                polygons.append(contentsOf: tile.mesh.polygons)
            }
        }
        
        let mesh = Mesh(polygons: polygons)
        
        geometry = SCNGeometry(mesh: mesh)
        
        let node = childNodes.first ?? SCNNode()

        if node.parent == nil {

            addChildNode(node)

            node.addChildNode(SCNNode())
            node.addChildNode(SCNNode())
        }

        node.childNodes.first?.geometry = SCNGeometry(wireframe: mesh)
        //node.childNodes.last?.geometry = SCNGeometry(normals: mesh)
        
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
        
        case segment
        case radius
        case tiles
    }
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(slice.segment, forKey: .segment)
        try container.encode(slice.radius, forKey: .radius)
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
