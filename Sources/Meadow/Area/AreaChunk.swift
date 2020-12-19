//
//  AreaChunk.swift
//
//  Created by Zack Brown on 08/12/2020.
//

import SceneKit

public class AreaChunk: SCNNode, Codable, Hideable, Responder, SceneGraphNode, Soilable, Updatable {
    
    private enum CodingKeys: CodingKey {
        
        case coordinate
        case tiles
    }
    
    public var ancestor: SoilableParent? { parent as? SoilableParent }
    
    public var isDirty: Bool = false
    
    public let coordinate: Coordinate
    var tiles: [AreaTile] = []
    
    public var children: [SceneGraphNode] { tiles }
    public var childCount: Int { children.count }
    public var isLeaf: Bool { children.isEmpty }
    public var category: Int { SceneGraphCategory.areaChunk.rawValue }
    
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
        tiles = try container.decode([AreaTile].self, forKey: .tiles)
        
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

extension AreaChunk {
    
    func add(tile coordinate: Coordinate) -> AreaTile? {
        
        guard find(tile: coordinate) == nil else { return nil }
        
        let tile = AreaTile(coordinate: coordinate)
        
        tiles.append(tile)
        
        tile.chunk = self
        
        becomeDirty()
        
        return tile
    }
    
    func find(tile coordinate: Coordinate) -> AreaTile? {
        
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

extension AreaChunk {
    
    @discardableResult public func clean() -> Bool {
        
        guard isDirty else { return false }
        
        guard let tilemap = meadow?.world.tilemaps.area else { return false }
        
        var polygons: [Polygon] = []
        
        for tile in tiles where !tile.isHidden {
            
            tile.clean()
            
            polygons.append(contentsOf: tile.render(position: Vector(coordinate: tile.coordinate.xz - coordinate.xz)))
        }
        
        let mesh = SCNGeometry(mesh: Mesh(polygons: polygons))
        
        let material = SCNMaterial()
        
        let edgeset = SCNMaterialProperty(contents: tilemap.edgeset.image)
        let tileset = SCNMaterialProperty(contents: tilemap.tileset.image)
        
        material.setValue(edgeset, forKey: "edgeset")
        material.setValue(tileset, forKey: "tileset")
        
        material.shaderModifiers = [.surface: """
                                        uniform sampler2D edgeset;
                                        uniform sampler2D tileset;
                                        
                                        vec3 up = vec3(0, 1, 0);
                                        vec3 normal = ((vec4(_surface.normal, 1.0))).xyz;

                                        if (dot(normal, up) < 0) {
                                            
                                            _surface.diffuse = texture2D(edgeset, _surface.diffuseTexcoord);
                                        }
                                        else {

                                            _surface.diffuse = texture2D(tileset, _surface.diffuseTexcoord);
                                        }
                                        """]
        
        mesh.materials = [material]
        
        geometry = mesh
        
        isDirty = false
        
        return true
    }
}

extension AreaChunk {
    
    func update(delta: TimeInterval, time: TimeInterval) {
        
        for tile in tiles where !tile.isHidden {
            
            tile.update(delta: delta, time: time)
        }
    }
}

extension AreaChunk {
    
    func contains(coordinate other: Coordinate) -> Bool {
        
        return other.x >= coordinate.x && other.x < (coordinate.x + World.Constants.chunkSize) && other.z >= coordinate.z && other.z < (coordinate.z + World.Constants.chunkSize)
    }
}
