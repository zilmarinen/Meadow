//
//  Surface.swift
//
//  Created by Zack Brown on 23/12/2020.
//

import SceneKit

public class Surface: SCNNode, Codable, Hideable, Responder, Soilable {
    
    private enum CodingKeys: CodingKey {
        
        case chunks
    }
    
    public var ancestor: SoilableParent? { return parent as? SoilableParent }
    
    public var isDirty: Bool = false
    
    var chunks: [SurfaceChunk] = []
    
    public var category: Int { SceneGraphCategory.surface.rawValue }
    
    required public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        chunks = try container.decode([SurfaceChunk].self, forKey: .chunks)
        
        super.init()
        
        categoryBitMask = category
        
        for chunk in chunks {
            
            for tile in chunk.tiles {
                
                for cardinal in Cardinal.allCases {
                 
                    if let neighbour = find(tile: tile.coordinate + cardinal.coordinate) {
                        
                        tile.add(neighbour: neighbour, cardinal: cardinal)
                    }
                }
            }
            
            addChildNode(chunk)
        }
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(chunks, forKey: .chunks)
    }
}

extension Surface {
    
    public func find(tile coordinate: Coordinate) -> SurfaceTile? {
        
        return find(chunk: coordinate)?.find(tile: coordinate)
    }
    
    func find(chunk coordinate: Coordinate) -> SurfaceChunk? {
        
        return chunks.first { $0.bounds.contains(coordinate: coordinate) }
    }
}

extension Surface {
    
    @discardableResult public func clean() -> Bool {
        
        guard isDirty else { return false }
        
        for chunk in chunks {
            
            chunk.clean()
        }
        
        isDirty = false
        
        return true
    }
}
