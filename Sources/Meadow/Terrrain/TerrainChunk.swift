//
//  TerrainChunk.swift
//
//  Created by Zack Brown on 02/11/2020.
//

import SceneKit

class TerrainChunk: SCNNode, Codable, SceneGraphNode, Soilable, Updatable {
    
    enum Constants {
        
        static var size = 5
    }
    
    private enum CodingKeys: CodingKey {
        
        case coordinate
        case tiles
    }
    
    var ancestor: SoilableParent? { return grid }
    
    var isDirty: Bool = false
    
    weak var grid: Terrain?
    let coordinate: Coordinate
    var tiles: [TerrainTile] = []
    
    var children: [SceneGraphNode] { tiles }
    var childCount: Int { tiles.count }
    var isLeaf: Bool { tiles.isEmpty }
    
    init(coordinate: Coordinate) {
        
        self.coordinate = coordinate
        self.tiles = []
        
        super.init()
        
        name = "Chunk \(coordinate.description)"
    }
    
    required init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        coordinate = try container.decode(Coordinate.self, forKey: .coordinate)
        tiles = try container.decode([TerrainTile].self, forKey: .tiles)
        
        super.init()
        
        tiles.forEach { tile in
            
            tile.chunk = self
        }
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(coordinate, forKey: .coordinate)
        try container.encode(tiles, forKey: .tiles)
    }
}

extension TerrainChunk {
    
    func add(tile coordinate: Coordinate) -> TerrainTile? {
        
        guard find(tile: coordinate) == nil else { return nil }
        
        let tile = TerrainTile(coordinate: coordinate)
        
        tiles.append(tile)
        
        tile.chunk = self
        
        return tile
    }
    
    func find(tile coordinate: Coordinate) -> TerrainTile? {
        
        return tiles.first { $0.coordinate.adjacency(to: coordinate) == .equal }
    }
    
    func remove(tile coordinate: Coordinate) {
        
        guard let index = tiles.firstIndex(where: { $0.coordinate.adjacency(to: coordinate) == .equal }) else { return }
        
        let tile = tiles[index]
        
        tile.chunk = nil
            
        tiles.remove(at: index)
    }
}

extension TerrainChunk {
    
    @discardableResult func clean() -> Bool {
        
        guard isDirty else { return false }
        
        tiles.forEach { tile in
            
            tile.clean()
        }
        
        return true
    }
}

extension TerrainChunk {
    
    func update(delta: TimeInterval, time: TimeInterval) {
        
        tiles.forEach { tile in
            
            tile.update(delta: delta, time: time)
        }
    }
}
