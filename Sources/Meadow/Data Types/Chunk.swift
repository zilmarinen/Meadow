//
//  Chunk.swift
//
//  Created by Zack Brown on 25/03/2021.
//

import Euclid
import SceneKit

public class Chunk<T: Tile>: SCNNode, Codable, Hideable, Responder, Shadable, Soilable {
    
    private enum CodingKeys: String, CodingKey {
        
        case coordinate = "c"
        case tiles = "t"
    }
    
    public var ancestor: SoilableParent? { parent as? SoilableParent }
    
    public var isDirty: Bool = false
    
    public var category: Int { SceneGraphCategory.surfaceChunk.rawValue }
    
    var bounds: GridBounds {
        
        didSet {
            
            if oldValue != bounds {
                
                becomeDirty()
            }
        }
    }
    let tiles: [T]
    
    public var program: SCNProgram? { nil }
    public var uniforms: [Uniform]? { nil }
    public var textures: [Texture]? { nil }
    
    var offset: Coordinate = .zero {
        
        didSet {
            
            if oldValue != offset {
                
                bounds = GridBounds(start: (bounds.start - oldValue) + offset, end: (bounds.end - oldValue) + offset)
                
                for tile in tiles {
                    
                    tile.offset = offset
                }
                
                becomeDirty()
            }
        }
    }
    
    required public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let coordinate = try container.decode(Coordinate.self, forKey: .coordinate)
        
        bounds = GridBounds(aligned: coordinate, size: World.Constants.chunkSize)
        tiles = try container.decode([T].self, forKey: .tiles)
        
        super.init()
        
        name = "Chunk \(self.bounds.start.description)"
        categoryBitMask = category
        
        for tile in tiles {
            
            tile.ancestor = self
        }
        
        becomeDirty()
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

extension Chunk {
    
    func find(tile coordinate: Coordinate) -> T? {
        
        return tiles.first { $0.coordinate.adjacency(to: coordinate) == .equal }
    }
}

extension Chunk {
    
    @discardableResult public func clean() -> Bool {
        
        guard isDirty else { return false }
        
        position = SCNVector3(coordinate: bounds.start)
        
        var polygons: [Euclid.Polygon] = []
        
        for tile in tiles where !tile.isHidden {
            
            tile.clean()
            
            polygons.append(contentsOf: tile.render(position: Vector(coordinate: tile.coordinate.xz - bounds.start.xz)))
        }
        
        let mesh = Mesh(polygons)
        
        self.geometry = SCNGeometry(mesh)
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
