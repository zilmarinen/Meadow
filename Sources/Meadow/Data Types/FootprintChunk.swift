//
//  FootprintChunk.swift
//
//  Created by Zack Brown on 27/03/2021.
//

import SceneKit

public class FootprintChunk: SCNNode, Codable, Hideable, Responder, Shadable, Soilable {
    
    private enum CodingKeys: String, CodingKey {
        
        case coordinate = "c"
    }
    
    public var ancestor: SoilableParent? { parent as? SoilableParent }
    
    public var isDirty: Bool = false
    
    public var category: Int { SceneGraphCategory.surfaceChunk.rawValue }
    
    public var coordinate: Coordinate
    
    var program: SCNProgram? { nil }
    var uniforms: [Uniform]? { nil }
    
    var textures: [Texture]? { nil }
    
    var offset: Coordinate = .zero {
        
        didSet {
            
            if oldValue != offset {
                
                coordinate += offset
                
                becomeDirty()
            }
        }
    }
    
    required public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        coordinate = try container.decode(Coordinate.self, forKey: .coordinate)
        
        super.init()
        
        name = "Chunk \(coordinate.description)"
        position = SCNVector3(coordinate: coordinate)
        categoryBitMask = category
        
        becomeDirty()
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(coordinate, forKey: .coordinate)
    }
    
    @discardableResult public func clean() -> Bool {
        
        guard isDirty else { return false }
        
        //
        
        isDirty = false
        
        return true
    }
}
