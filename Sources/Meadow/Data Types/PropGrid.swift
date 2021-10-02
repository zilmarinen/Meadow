//
//  PropGrid.swift
//
//  Created by Zack Brown on 27/03/2021.
//

import SceneKit

public class PropGrid<C: PropChunk>: SCNNode, Codable, Hideable, Responder, Soilable {
    
    private enum CodingKeys: String, CodingKey {
        
        case chunks = "c"
    }
    
    public var ancestor: SoilableParent? { return parent as? SoilableParent }
    
    public var isDirty: Bool = false
    
    public var category: SceneGraphCategory { .surface }
    
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
    
    override init() {
        
        chunks = []
        
        super.init()
        
        categoryBitMask = category.rawValue
    }
    
    required public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        chunks = try container.decode([C].self, forKey: .chunks)
        
        super.init()
        
        categoryBitMask = category.rawValue
        
        for chunk in chunks {
            
            addChildNode(chunk)
        }
        
        becomeDirty()
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
}

extension PropGrid {
    
    @discardableResult public func clean() -> Bool {
        
        guard isDirty else { return false }
        
        for chunk in chunks {
            
            chunk.clean()
        }
        
        isDirty = false
        
        return true
    }
}

extension PropGrid {
    
    func find(chunk coordinate: Coordinate) -> C? {
        
        guard let props = scene?.props else { return nil }
        
        return chunks.first { props.model(prop: $0.prop)?.footprint.intersects(coordinate: coordinate) ?? false }
    }
}
