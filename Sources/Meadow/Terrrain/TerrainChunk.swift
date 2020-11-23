//
//  TerrainChunk.swift
//
//  Created by Zack Brown on 02/11/2020.
//

import SceneKit

public class TerrainChunk: SCNNode, Codable, Hideable, Responder, SceneGraphNode, Soilable, Updatable {
    
    enum Constants {
        
        static var size = 5
    }
    
    private enum CodingKeys: CodingKey {
        
        case coordinate
        case tiles
    }
    
    public var ancestor: SoilableParent? { return grid }
    
    public var isDirty: Bool = false
    
    weak var grid: Terrain?
    let coordinate: Coordinate
    var tiles: [TerrainTile] = []
    
    public var children: [SceneGraphNode] { tiles }
    public var childCount: Int { children.count }
    public var isLeaf: Bool { children.isEmpty }
    public var category: Int { SceneGraphCategory.terrainChunk.rawValue }
    
    init(coordinate: Coordinate) {
        
        self.coordinate = Coordinate(x: coordinate.x - (coordinate.x % Constants.size), y: 0, z: coordinate.z - (coordinate.z % Constants.size))
        self.tiles = []
        
        super.init()
        
        name = "Chunk \(self.coordinate.description)"
        position = SCNVector3(coordinate: self.coordinate)
        categoryBitMask = category
    }
    
    required public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        coordinate = try container.decode(Coordinate.self, forKey: .coordinate)
        tiles = try container.decode([TerrainTile].self, forKey: .tiles)
        
        super.init()
        
        categoryBitMask = category
        
        tiles.forEach { tile in
            
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

extension TerrainChunk {
    
    func add(tile coordinate: Coordinate) -> TerrainTile? {
        
        guard find(tile: coordinate) == nil else { return nil }
        
        let tile = TerrainTile(coordinate: coordinate)
        
        tiles.append(tile)
        
        tile.chunk = self
        
        becomeDirty()
        
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
        
        becomeDirty()
    }
}

extension TerrainChunk {
    
    @discardableResult public func clean() -> Bool {
        
        guard isDirty else { return false }
        
        guard let tileset = tileset else { return false }
        
        var polygons: [Polygon] = []
        
        for child in childNodes {
            
            child.removeFromParentNode()
        }
        
        for tile in tiles where !tile.isHidden {
            
            tile.clean()
            
            let polys = tile.render(position: Vector(coordinate: Coordinate(x: tile.coordinate.x, y: 0, z: tile.coordinate.z) - Coordinate(x: coordinate.x, y: 0, z: coordinate.z)))
            
            polygons.append(contentsOf: polys)
            
            for cardinal in Cardinal.allCases {
                
                let box = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0)
                
                let node = SCNNode(geometry: box)
                
                let vector = Vector(coordinate: Coordinate(x: tile.coordinate.x, y: 0, z: tile.coordinate.z) - Coordinate(x: coordinate.x, y: 0, z: coordinate.z))
                
                node.position = SCNVector3(vector: vector + (cardinal.normal * Vector(x: 0.25, y: 0.0, z: 0.25)))
                
                box.firstMaterial?.diffuse.contents = (tile.traversable(cardinal: cardinal) ? MDWColor.systemGreen : MDWColor.systemRed)
                
                addChildNode(node)
            }
        }
        
        geometry = SCNGeometry(mesh: Mesh(polygons: polygons))
        geometry?.firstMaterial?.diffuse.contents = tileset.image
        
        isDirty = false
        
        return true
    }
}

extension TerrainChunk {
    
    func update(delta: TimeInterval, time: TimeInterval) {
        
        for tile in tiles where !tile.isHidden {
            
            tile.update(delta: delta, time: time)
        }
    }
}

extension TerrainChunk {
    
    func contains(coordinate other: Coordinate) -> Bool {
        
        return other.x >= coordinate.x && other.x < (coordinate.x + Constants.size) && other.z >= coordinate.z && other.z < (coordinate.z + Constants.size)
    }
}
