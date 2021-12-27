//
//  Chunk.swift
//
//  Created by Zack Brown on 25/03/2021.
//

import Euclid
import SceneKit

public class Chunk<T: Tile>: SCNNode, Decodable, Hideable, Responder, Shadable, Soilable {
    
    private enum CodingKeys: String, CodingKey {
        
        case coordinate = "c"
        case tiles = "t"
    }
    
    public var ancestor: SoilableParent? { parent as? SoilableParent }
    
    public var isDirty: Bool = false
    
    public var category: SceneGraphCategory { .surfaceChunk }
    
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
            }
        }
    }
    
    required public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let coordinate = try container.decode(Coordinate.self, forKey: .coordinate)
        
        bounds = GridBounds(aligned: coordinate, size: World.Constants.chunkSize)
        tiles = try container.decode([T].self, forKey: .tiles)
        
        super.init()
        
        name = "Chunk \(self.bounds.start.id)"
        categoryBitMask = category.rawValue
        
        for tile in tiles {
            
            tile.ancestor = self
        }
        
        becomeDirty()
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    @discardableResult public func clean() -> Bool {
        
        guard isDirty else { return false }
        
        position = SCNVector3(coordinate: bounds.start)
        
        //geometry?.program = program
        
        if let uniforms = uniforms {
            
            geometry?.set(uniforms: uniforms)
        }
        
        if let textures = textures {
            
            geometry?.set(textures: textures)
        }
        
        isDirty = false
        
        return true
    }
}

extension Chunk {
    
    func find(tile coordinate: Coordinate) -> T? {
        
        return tiles.first { $0.coordinate.adjacency(to: coordinate) == .equal }
    }
}
