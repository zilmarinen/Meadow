//
//  Foliage.swift
//
//  Created by Zack Brown on 07/12/2020.
//

import SceneKit

public class Foliage: SCNNode, Codable, Hideable, Responder, SceneGraphNode, Soilable, Updatable {
    
    private enum CodingKeys: CodingKey {
        
        case name
        case chunks
    }
    
    public var ancestor: SoilableParent? { return parent as? SoilableParent }
    
    public var isDirty: Bool = false
    
    var chunks: [FoliageChunk] = []
    
    public var children: [SceneGraphNode] { chunks }
    public var childCount: Int { children.count }
    public var isLeaf: Bool { children.isEmpty }
    public var category: Int { SceneGraphCategory.foliage.rawValue }
    
    override init() {
        
        super.init()
        
        name = "Foliage"
        categoryBitMask = category
    }
    
    required public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        chunks = try container.decode([FoliageChunk].self, forKey: .chunks)
        
        super.init()
        
        name = try container.decode(String.self, forKey: .name)
        categoryBitMask = category
        
        for chunk in chunks {
            
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

extension Foliage {
    
    public typealias TileConfiguration = ((FoliageTile) -> Void)
    
    public func add(tile coordinate: Coordinate, configure: TileConfiguration? = nil) -> FoliageTile? {
        
        guard find(tile: coordinate) == nil else { return nil }
        
        let chunk = find(chunk: coordinate) ?? FoliageChunk(coordinate: coordinate)
        
        guard let tile = chunk.add(tile: coordinate) else { return nil }
        
        if chunk.grid == nil {
            
            chunk.grid = self
            
            chunks.append(chunk)
            
            addChildNode(chunk)
        }
        
        for cardinal in Cardinal.allCases {
         
            if let neighbour = find(tile: coordinate + cardinal.coordinate) {
                
                tile.add(neighbour: neighbour, cardinal: cardinal)
            }
        }
        
        configure?(tile)
        
        becomeDirty()
        
        return tile
    }
    
    public func find(tile coordinate: Coordinate) -> FoliageTile? {
        
        return find(chunk: coordinate)?.find(tile: coordinate)
    }
    
    public func remove(tile coordinate: Coordinate) {
        
        guard let chunk = find(chunk: coordinate) else { return }
        
        chunk.remove(tile: coordinate)
        
        guard chunk.tiles.isEmpty,
              let index = chunks.firstIndex(of: chunk) else { return }
        
        chunk.grid = nil
        
        chunks.remove(at: index)
        
        chunk.removeFromParentNode()
        
        becomeDirty()
    }
    
    func find(chunk coordinate: Coordinate) -> FoliageChunk? {
        
        return chunks.first { $0.contains(coordinate: coordinate) }
    }
}

extension Foliage {
    
    @discardableResult public func clean() -> Bool {
        
        guard isDirty else { return false }
        
        for chunk in chunks {
            
            chunk.clean()
        }
        
        isDirty = false
        
        return true
    }
}

extension Foliage {
    
    func update(delta: TimeInterval, time: TimeInterval) {
        
        for chunk in chunks {
            
            chunk.update(delta: delta, time: time)
        }
    }
}
