//
//  Terrain.swift
//
//  Created by Zack Brown on 02/11/2020.
//

import SceneKit

public class Terrain: SCNNode, Codable, Hideable, Responder, SceneGraphNode, Soilable, Updatable {
    
    private enum CodingKeys: CodingKey {
        
        case name
        case chunks
    }
    
    public var ancestor: SoilableParent? { return parent as? SoilableParent }
    
    public var isDirty: Bool = false {
        
        didSet {
            
            guard oldValue != isHidden else { return }
            
            becomeDirty()
        }
    }
    
    var chunks: [TerrainChunk] = []
    
    public var children: [SceneGraphNode] { chunks }
    public var childCount: Int { children.count }
    public var isLeaf: Bool { children.isEmpty }
    public var category: Int { SceneGraphCategory.terrain.rawValue }
    
    override init() {
        
        super.init()
        
        name = "Terrain"
        categoryBitMask = category
    }
    
    required public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        chunks = try container.decode([TerrainChunk].self, forKey: .chunks)
        
        super.init()
        
        name = try container.decode(String.self, forKey: .name)
        categoryBitMask = category
        
        chunks.forEach { chunk in
            
            chunk.grid = self
            
            addChildNode(chunk)
        }
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(name, forKey: .name)
        try container.encode(chunks, forKey: .chunks)
    }
}

extension Terrain {
    
    public func add(tile coordinate: Coordinate, layer tileType: TerrainTileType = .water) -> TerrainTile? {
        
        guard find(tile: coordinate) == nil else { return nil }
        
        let chunk = find(chunk: coordinate) ?? TerrainChunk(coordinate: coordinate)
        
        guard let tile = chunk.add(tile: coordinate) else { return nil }
        
        if chunk.grid == nil {
            
            chunk.grid = self
            
            chunks.append(chunk)
            
            addChildNode(chunk)
        }
        
        Cardinal.allCases.forEach { cardinal in
         
            if let neighbour = find(tile: coordinate + cardinal.coordinate) {
                
                tile.add(neighbour: neighbour, cardinal: cardinal)
            }
        }
        
        tile.set(layer: tileType)
        
        becomeDirty()
        
        return tile
    }
    
    public func find(tile coordinate: Coordinate) -> TerrainTile? {
        
        return find(chunk: coordinate)?.find(tile: coordinate)
    }
    
    public func remove(tile coordinate: Coordinate) {
        
        guard let chunk = find(chunk: coordinate) else { return }
        
        chunk.remove(tile: coordinate)
        
        guard chunk.tiles.isEmpty else { return }
        
        chunk.grid = nil
        
        chunk.removeFromParentNode()
        
        becomeDirty()
    }
    
    func find(chunk coordinate: Coordinate) -> TerrainChunk? {
        
        return chunks.first { $0.contains(coordinate: coordinate) }
    }
}

extension Terrain {
    
    @discardableResult public func clean() -> Bool {
        
        guard isDirty else { return false }
        
        chunks.forEach { chunk in
            
            chunk.clean()
        }
        
        isDirty = false
        
        return true
    }
}

extension Terrain {
    
    func update(delta: TimeInterval, time: TimeInterval) {
        
        chunks.forEach { chunk in
            
            chunk.update(delta: delta, time: time)
        }
    }
}
