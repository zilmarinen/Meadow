//
//  FootprintChunk.swift
//
//  Created by Zack Brown on 27/03/2021.
//

import SceneKit

public class FootprintChunk: SCNNode, Codable, Hideable, Responder, Shadable, Soilable {
    
    private enum CodingKeys: String, CodingKey {
        
        case coordinate = "co"
        case direction = "d"
    }
    
    public var ancestor: SoilableParent? { parent as? SoilableParent }
    
    public var isDirty: Bool = false
    
    public var category: SceneGraphCategory { .surfaceChunk }
    
    public var footprint: Footprint { Footprint(coordinate: coordinate, rotation: direction, nodes: prop.footprint.nodes) }
    
    public var prop: Model { fatalError("prop has not been implemented") }
    
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
        categoryBitMask = category.rawValue
        
        becomeDirty()
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    @discardableResult public func clean() -> Bool {
        
        guard isDirty else { return false }
        
        position = SCNVector3(coordinate.world)
        
        geometry?.program = program
        
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
