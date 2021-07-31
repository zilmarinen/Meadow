//
//  FootprintChunk.swift
//
//  Created by Zack Brown on 27/03/2021.
//

import SceneKit

public class FootprintChunk: SCNNode, Codable, FootprintDataSource, Hideable, Responder, Shadable, Soilable {
    
    private enum CodingKeys: String, CodingKey {
        
        case coordinate = "co"
        case direction = "d"
    }
    
    public var ancestor: SoilableParent? { parent as? SoilableParent }
    
    public var isDirty: Bool = false
    
    public var category: Int { SceneGraphCategory.surfaceChunk.rawValue }
    
    public var footprint: Footprint { Footprint(coordinate: coordinate, nodes: [.zero]) }
    
    private(set) public var coordinate: Coordinate {
        
        didSet {
            
            if oldValue != coordinate {
            
                becomeDirty()
            }
        }
    }
    
    public let direction: Cardinal
    
    public var program: SCNProgram? { nil }
    public var uniforms: [Uniform]? { nil }
    public var textures: [Texture]? { nil }
    
    var offset: Coordinate = .zero {
        
        didSet {
            
            if oldValue != offset {
                
                coordinate = (coordinate - oldValue) + offset
                
                becomeDirty()
            }
        }
    }
    
    required public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        coordinate = try container.decode(Coordinate.self, forKey: .coordinate)
        direction = try container.decode(Cardinal.self, forKey: .direction)
        
        super.init()
        
        name = "Chunk \(coordinate.description)"
        categoryBitMask = category
        
        becomeDirty()
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(coordinate, forKey: .coordinate)
        try container.encode(direction, forKey: .direction)
    }
    
    @discardableResult public func clean() -> Bool {
        
        guard isDirty else { return false }
        
        position = SCNVector3(coordinate.xz.world)
        
        isDirty = false
        
        return true
    }
}
