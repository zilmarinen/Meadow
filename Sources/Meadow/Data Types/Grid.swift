//
//  Grid.swift
//
//  Created by Zack Brown on 25/03/2021.
//

import SceneKit

public class Grid<C: Chunk<T>, T: Tile>: SCNNode, Decodable, Hideable, Responder, Soilable {
    
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
        
        isDirty = chunks.map { $0.isDirty }.contains(true)
        
        return true
    }
}
