//
//  FoliageChunk.swift
//
//  Created by Zack Brown on 07/12/2020.
//

import SceneKit

public class FoliageChunk: SCNNode, Codable, Hideable, Responder, SceneGraphNode, Soilable, Updatable {
    
    private enum CodingKeys: CodingKey {
        
        case coordinate
        case tiles
    }
    
    public var ancestor: SoilableParent? { parent as? SoilableParent }
    
    public var isDirty: Bool = false
    
    public let coordinate: Coordinate
    var tiles: [FoliageTile] = []
    
    public var children: [SceneGraphNode] { tiles }
    public var childCount: Int { children.count }
    public var isLeaf: Bool { children.isEmpty }
    public var category: Int { SceneGraphCategory.foliageChunk.rawValue }
    
    init(coordinate: Coordinate) {
        
        self.coordinate = Coordinate(x: coordinate.x, z: coordinate.z, size: World.Constants.chunkSize)
        self.tiles = []
        
        super.init()
        
        name = "Chunk \(self.coordinate.description)"
        position = SCNVector3(coordinate: self.coordinate)
        categoryBitMask = category
    }
    
    required public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        coordinate = try container.decode(Coordinate.self, forKey: .coordinate)
        tiles = try container.decode([FoliageTile].self, forKey: .tiles)
        
        super.init()
        
        name = "Chunk \(self.coordinate.description)"
        position = SCNVector3(coordinate: self.coordinate)
        categoryBitMask = category
        
        for tile in tiles {
            
            tile.chunk = self
        }
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(coordinate, forKey: .coordinate)
        try container.encode(tiles, forKey: .tiles)
    }
}

extension FoliageChunk {
    
    func add(tile coordinate: Coordinate) -> FoliageTile? {
        
        guard find(tile: coordinate) == nil else { return nil }
        
        let tile = FoliageTile(coordinate: coordinate)
        
        tiles.append(tile)
        
        tile.chunk = self
        
        becomeDirty()
        
        return tile
    }
    
    func find(tile coordinate: Coordinate) -> FoliageTile? {
        
        return tiles.first { $0.coordinate.adjacency(to: coordinate) == .equal }
    }
    
    func remove(tile coordinate: Coordinate) {
        
        guard let index = tiles.firstIndex(where: { $0.coordinate.adjacency(to: coordinate) == .equal }) else { return }
        
        let tile = tiles[index]
        
        tile.chunk = nil
            
        tiles.remove(at: index)
        
        becomeDirty()
    }
}

extension FoliageChunk {
    
    @discardableResult public func clean() -> Bool {
        
        guard isDirty else { return false }
        
        //
        
        isDirty = false
        
        return true
    }
}

extension FoliageChunk {
    
    func update(delta: TimeInterval, time: TimeInterval) {
        
        for tile in tiles where !tile.isHidden {
            
            tile.update(delta: delta, time: time)
        }
    }
}

extension FoliageChunk {
    
    func contains(coordinate other: Coordinate) -> Bool {
        
        return other.x >= coordinate.x && other.x < (coordinate.x + World.Constants.chunkSize) && other.z >= coordinate.z && other.z < (coordinate.z + World.Constants.chunkSize)
    }
}
