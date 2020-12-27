//
//  Chunk.swift
//
//  Created by Zack Brown on 23/12/2020.
//

import SceneKit

public class Chunk<T: Tile>: SCNNode, Codable, Hideable, Responder, SceneGraphNode, Shadable, Soilable, Updatable {
    
    private enum CodingKeys: CodingKey {
        
        case coordinate
        case tiles
    }
    
    public var ancestor: SoilableParent? { parent as? SoilableParent }
    
    public var isDirty: Bool {
        
        get {
            
            children.compactMap { $0 as? Soilable }.first { $0.isDirty } != nil
        }
        
        set {
            
            guard !isDirty, newValue else { return }
            
            for child in children {
                
                guard let child = child as? SceneGraphNode & Soilable else { continue }
                
                child.becomeDirty()
            }
        }
    }
    
    public let coordinate: Coordinate
    var tiles: [T] = []
    
    public var children: [SceneGraphNode] { tiles }
    public var childCount: Int { children.count }
    public var isLeaf: Bool { children.isEmpty }
    public var category: Int { fatalError("Chunk.category must be overridden") }
    
    var program: SCNProgram? { nil }
    var uniforms: [Uniform]? { nil }
    var textures: [Texture]? { nil }
    
    required init(coordinate: Coordinate) {
        
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
        tiles = try container.decode([T].self, forKey: .tiles)
        
        super.init()
        
        name = "Chunk \(self.coordinate.description)"
        position = SCNVector3(coordinate: self.coordinate)
        categoryBitMask = category
        
        for tile in tiles {
            
            tile.ancestor = self
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

extension Chunk {
    
    func add(tile coordinate: Coordinate) -> T? {
        
        guard find(tile: coordinate) == nil else { return nil }
        
        let tile = T(coordinate: coordinate)
        
        tiles.append(tile)
        
        tile.ancestor = self
        
        becomeDirty()
        
        return tile
    }
    
    func find(tile coordinate: Coordinate) -> T? {
        
        return tiles.first { $0.coordinate.adjacency(to: coordinate) == .equal }
    }
    
    func remove(tile coordinate: Coordinate) {
        
        guard let index = tiles.firstIndex(where: { $0.coordinate.adjacency(to: coordinate) == .equal }) else { return }
        
        let tile = tiles[index]
        
        tile.ancestor = nil
            
        tiles.remove(at: index)
        
        becomeDirty()
    }
}

extension Chunk {
    
    @discardableResult public func clean() -> Bool {
        
        guard isDirty else { return false }
        
        var polygons: [Polygon] = []
        
        let collapsable = tiles as [Collapsable]
        
        collapsable.collapse()
        
        for tile in tiles where !tile.isHidden {
            
            tile.clean()
            
            polygons.append(contentsOf: tile.render(position: Vector(coordinate: tile.coordinate.xz - coordinate.xz)))
        }
        
        let mesh = Mesh(polygons: polygons)
        
        self.geometry = SCNGeometry(mesh: mesh)
        self.geometry?.program = program
        
        if let uniforms = uniforms {
            
            self.geometry?.set(uniforms: uniforms)
        }
        
        if let textures = textures {
            
            self.geometry?.set(textures: textures)
        }
        
        isDirty = false
        
        return true
    }
}

extension Chunk {
    
    func update(delta: TimeInterval, time: TimeInterval) {
        
        for tile in tiles where !tile.isHidden {
            
            tile.update(delta: delta, time: time)
        }
    }
}

extension Chunk {
    
    func contains(coordinate other: Coordinate) -> Bool {
        
        return other.x >= coordinate.x && other.x < (coordinate.x + World.Constants.chunkSize) && other.z >= coordinate.z && other.z < (coordinate.z + World.Constants.chunkSize)
    }
}
