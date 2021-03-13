//
//  SurfaceChunk.swift
//
//  Created by Zack Brown on 23/12/2020.
//

import SceneKit

public class SurfaceChunk: SCNNode, Codable, Hideable, Responder, Shadable, Soilable {
    
    private enum CodingKeys: CodingKey {
        
        case coordinate
        case tiles
    }
    
    public var ancestor: SoilableParent? { parent as? SoilableParent }
    
    public var isDirty: Bool = false
    
    public let bounds: GridBounds
    var tiles: [SurfaceTile] = []
    
    public var category: Int { SceneGraphCategory.surfaceChunk.rawValue }
    
    var program: SCNProgram? {
        
        guard let library = scene?.library else { return nil }
        
        return SCNProgram(name: "surface", library: library)
    }
    
    var uniforms: [Uniform]? { nil }
    
    var textures: [Texture]? {
        
        guard let tilemap = scene?.world.tilemaps.surface else { return [] }
        
        return [Texture(key: "edgeset", image: tilemap.edgeset.image),
                Texture(key: "tileset", image: tilemap.tileset.image)]
    }
    
    required public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let coordinate = try container.decode(Coordinate.self, forKey: .coordinate)
        
        bounds = GridBounds(aligned: coordinate, size: World.Constants.chunkSize)
        tiles = try container.decode([SurfaceTile].self, forKey: .tiles)
        
        super.init()
        
        name = "Chunk \(self.bounds.start.description)"
        position = SCNVector3(coordinate: self.bounds.start)
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
        
        try container.encode(bounds.start, forKey: .coordinate)
        try container.encode(tiles, forKey: .tiles)
    }
}

extension SurfaceChunk {
    
    func find(tile coordinate: Coordinate) -> SurfaceTile? {
        
        return tiles.first { $0.coordinate.adjacency(to: coordinate) == .equal }
    }
}

extension SurfaceChunk {
    
    @discardableResult public func clean() -> Bool {
        
        guard isDirty else { return false }
        
        //TODO: generate mesh
        let mesh = Mesh(polygons: [])
        
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
