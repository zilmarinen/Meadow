//
//  Grid.swift
//  Meadow
//
//  Created by Zack Brown on 07/02/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

import Foundation
import SceneKit
import Pasture

public class Grid<C: Chunk<T>, T: Tile>: SCNNode, Hideable, SceneGraphIdentifiable, SceneGraphNode, Soilable {

    public weak var ancestor: SoilableParent?
    
    public var identifier: Int = SceneGraphNodeType.grid.rawValue
    
    public weak var graph: Graph?

    public var isDirty = false
    
    var chunks: [C] = []
    
    public override var isHidden: Bool {
        
        didSet {
            
            becomeDirty()
        }
    }
    
    public init(graph: Graph, ancestor: SoilableParent) {
        
        self.ancestor = ancestor
        
        self.graph = graph
        
        super.init()
        
        categoryBitMask = category.rawValue
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func addChildNode(_ child: SCNNode) {
        
        guard let chunk = child as? C, chunk.parent == nil else { return }
        
        super.addChildNode(chunk)
        
        chunks.append(chunk)
        
        becomeDirty()
    }
    
    public var children: [SceneGraphNode] { return chunks }
    
    public var childCount: Int { return children.count }
    
    public var isLeaf: Bool { return children.isEmpty }
    
    public var category: SceneGraphNodeCategory { fatalError("Grid.category must be overridden") }
    
    public var type: SceneGraphNodeType { return .grid }
    
    public func add(tile vector: Vector) -> T? {
        
        guard let quad = graph?.data.quads.first, let joints = graph?.joints(for: quad), let vectors = graph?.vectors(for: quad) else { return nil }
        
        let slice = chunkSlice(for: vector)
        
        let chunk = find(chunk: vector) ?? C(ancestor: self, slice: slice)
        
        let tile = chunk.add(tile: quad.i, joints: joints, vectors: vectors)
        
        addChildNode(chunk)
        
        for joint in joints where joint.e1 != -1 {
            
            let identifier = (joint.e0 == tile.identifier ? joint.e1 : joint.e0)
            
            if let neighbour = find(tile: identifier) {
                
                tile.add(neighbour: neighbour, identifier: joint.i)
            }
        }
        
        return tile
    }
    
    public func add(tile identifier: Int) -> T? {
        
        guard let quad = graph?.quad(at: identifier), let joints = graph?.joints(for: quad), let vectors = graph?.vectors(for: quad) else { return nil }
        
        let slice = chunkSlice(for: quad.v)
        
        let chunk = find(chunk: quad.v) ?? C(ancestor: self, slice: slice)
        
        let tile = chunk.add(tile: quad.i, joints: joints, vectors: vectors)
        
        addChildNode(chunk)
        
        for joint in joints where joint.e1 != -1 {
            
            let identifier = (joint.i0 == tile.identifier ? joint.i1 : joint.i0)
            
            if let neighbour = find(tile: identifier) {
                
                tile.add(neighbour: neighbour, identifier: joint.i)
            }
        }
        
        return tile
    }
}

extension Grid {
    
    func find(chunk vector: Vector) -> C? {
        
        let slice = chunkSlice(for: vector)
        
        return chunks.first { chunk in
            
            return chunk.slice == slice
        }
    }
    
    func find(tile identifier: Int) -> T? {
        
        for index in chunks.indices {
            
            if let tile = chunks[index].find(tile: identifier) {
                
                return tile
            }
        }
        
        return nil
    }
    
    func find(tile vector: Vector) -> T? {
        
        guard let chunk = find(chunk: vector), let tile = chunk.find(tile: vector) else { return nil }
        
        return tile
    }
    
    func remove(tile identifier: Int) {
        
        guard let tile = find(tile: identifier), let chunk = find(chunk: tile.centre) else { return }
        
        chunk.remove(tile: tile.identifier)
        
        if chunk.tiles.count == 0 {
            
            chunk.removeFromParentNode()
        }
    }
    
    func remove(tile vector: Vector) {
        
        guard let chunk = find(chunk: vector), let tile = chunk.find(tile: vector) else { return }
        
        chunk.remove(tile: tile.identifier)
        
        if chunk.tiles.count == 0 {
            
            chunk.removeFromParentNode()
        }
    }
    
    func chunkSlice(for vector: Vector) -> C.Slice {
        
        return C.Slice(vector: vector)
    }
}

extension Grid {
    
    @discardableResult public func clean() -> Bool {
        
        guard isDirty else { return false }
        
        chunks.forEach { chunk in
            
            chunk.clean()
        }
        
        isDirty = false
        
        return true
    }
}

extension Grid: Clearable {
    
    func clear() {
        
        while(chunks.count > 0) {
            
            let chunk = chunks.removeLast()
            
            chunk.clear()
            
            chunk.removeFromParentNode()
        }
    }
}

extension Grid: Encodable {
    
    enum CodingKeys: CodingKey {
        
        case name
        case chunks
    }
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(name, forKey: .name)
        try container.encode(chunks, forKey: .chunks)
    }
}

extension Grid: Updatable {
    
    func update(delta: TimeInterval, time: TimeInterval) {
        
        chunks.forEach { chunk in
            
            chunk.update(delta: delta, time: time)
        }
    }
}
