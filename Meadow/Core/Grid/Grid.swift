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
    
    public var coordinate: Coordinate { return .zero }

    public var isDirty = false
    
    var chunks: [C] = []
    
    public override var isHidden: Bool {
        
        didSet {
            
            becomeDirty()
        }
    }
    
    public init(ancestor: SoilableParent) {
        
        self.ancestor = ancestor
        
        super.init()
        
        categoryBitMask = category.rawValue
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func addChildNode(_ child: SCNNode) {
        
        guard let chunk = child as? C else { return }
        
        super.addChildNode(chunk)
        
        chunks.append(chunk)
        
        becomeDirty()
    }
    
    public var children: [SceneGraphNode] { return chunks }
    
    public var childCount: Int { return children.count }
    
    public var isLeaf: Bool { return children.isEmpty }
    
    public var category: SceneGraphNodeCategory { fatalError("Grid.category must be overridden") }
    
    public var type: SceneGraphNodeType { return .grid }
    
    func add(tile coordinate: Coordinate) -> T {
        
        let chunk = find(chunk: coordinate) ?? C(ancestor: self, coordinate: coordinate)
        
        let tile = chunk.add(tile: coordinate)
        
        if chunk.parent == nil {
            
            addChildNode(chunk)
        }
        
        Cardinal.allCases.forEach { cardinal in
            
            if let neighbour = find(tile: coordinate + Coordinate.cardinal(cardinal: cardinal)) {
                
                tile.add(neighbour: neighbour, cardinal: cardinal)
            }
        }
        
        return tile
    }
}

extension Grid {
    
    func find(chunk coordinate: Coordinate) -> C? {
        
        return chunks.first { chunk in
            
            return chunk.volume.contains(coordinate: coordinate)
        }
    }
    
    func find(tile coordinate: Coordinate) -> T? {
        
        guard let chunk = find(chunk: coordinate), let tile = chunk.find(tile: coordinate) else { return nil }
        
        return tile
    }
    
    func remove(tile coordinate: Coordinate) {
        
        guard let chunk = find(chunk: coordinate) else { return }
        
        chunk.remove(tile: coordinate)
        
        if chunk.tiles.count == 0 {
            
            chunk.removeFromParentNode()
        }
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
