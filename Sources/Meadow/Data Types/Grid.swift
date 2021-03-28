//
//  Grid.swift
//
//  Created by Zack Brown on 25/03/2021.
//

import SceneKit

public class Grid<C: Chunk<T>, T: Tile>: SCNNode, Codable, Hideable, Responder, Soilable {
    
    private enum CodingKeys: CodingKey {
        
        case chunks
    }
    
    public var ancestor: SoilableParent? { return parent as? SoilableParent }
    
    public var isDirty: Bool = false
    
    public var category: Int { SceneGraphCategory.surface.rawValue }
    
    let chunks: [C]
    
    required public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        chunks = try container.decode([C].self, forKey: .chunks)
        
        super.init()
        
        categoryBitMask = category
        
        for chunk in chunks {
            
            addChildNode(chunk)
        }
        
        becomeDirty()
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(chunks, forKey: .chunks)
    }
}

extension Grid {
    
    public func find(tile coordinate: Coordinate) -> T? {
        
        return find(chunk: coordinate)?.find(tile: coordinate)
    }
    
    func find(chunk coordinate: Coordinate) -> C? {
        
        return chunks.first { $0.bounds.contains(coordinate: coordinate) }
    }
}

extension Grid {
    
    @discardableResult public func clean() -> Bool {
        
        guard isDirty else { return false }
        
        for chunk in chunks {
            
            chunk.clean()
        }
        
        isDirty = false
        
        return true
    }
}
