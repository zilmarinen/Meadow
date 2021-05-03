//
//  FootprintGrid.swift
//
//  Created by Zack Brown on 27/03/2021.
//

import SceneKit

public class FootprintGrid<C: FootprintChunk>: SCNNode, Codable, Hideable, Responder, Soilable {
    
    private enum CodingKeys: String, CodingKey {
        
        case chunks = "c"
    }
    
    public var ancestor: SoilableParent? { return parent as? SoilableParent }
    
    public var isDirty: Bool = false
    
    public var category: Int { SceneGraphCategory.surface.rawValue }
    
    let chunks: [C]
    
    var offset: Coordinate = .zero {
        
        didSet {
            
            if oldValue != offset {
                
                for chunk in chunks {
                    
                    chunk.offset = offset
                }
                
                becomeDirty()
            }
        }
    }
    
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

extension FootprintGrid {
    
    @discardableResult public func clean() -> Bool {
        
        guard isDirty else { return false }
        
        for chunk in chunks {
            
            chunk.clean()
        }
        
        isDirty = false
        
        return true
    }
}

