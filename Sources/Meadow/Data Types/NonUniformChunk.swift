//
//  NonUniformChunk.swift
//
//  Created by Zack Brown on 27/03/2021.
//

import SceneKit

public class NonUniformChunk: SCNNode, Codable, Hideable, Responder, Shadable, Soilable {
    
    private enum CodingKeys: CodingKey {
        
        case footprint
    }
    
    public var ancestor: SoilableParent? { parent as? SoilableParent }
    
    public var isDirty: Bool = false
    
    public var category: Int { SceneGraphCategory.surfaceChunk.rawValue }
    
    public let footprint: Footprint
    
    var program: SCNProgram? { nil }
    var uniforms: [Uniform]? { nil }
    
    var textures: [Texture]? { nil }
    
    required public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        footprint = try container.decode(Footprint.self, forKey: .footprint)
        
        super.init()
        
        name = "Chunk \(footprint.coordinate.description)"
        position = SCNVector3(coordinate: footprint.coordinate)
        categoryBitMask = category
        
        becomeDirty()
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(footprint, forKey: .footprint)
    }
    
    @discardableResult public func clean() -> Bool {
        
        guard isDirty else { return false }
        
        let size = footprint.bounds.size
        
        let x = CGFloat(footprint.coordinate.x) + ((size.width - 1) * 0.5)
        let z = CGFloat(footprint.coordinate.z) + ((size.height - 1) * 0.5)
        
        position = SCNVector3(x: x, y: CGFloat(Double(footprint.coordinate.y) * World.Constants.slope) + 0.5, z: z)
        
        self.geometry = SCNBox(width: size.width, height: 1.0, length: size.height, chamferRadius: 0.0)
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
