//
//  Actor.swift
//
//  Created by Zack Brown on 28/03/2021.
//

import SceneKit

public class Actor: SCNNode, Codable, Hideable, Responder, Shadable, Soilable, Updatable {
    
    private enum CodingKeys: CodingKey {
        
        case coordinate
    }
    
    public var ancestor: SoilableParent? { parent as? SoilableParent }
    
    public var isDirty: Bool = false
    
    public var category: Int { SceneGraphCategory.surfaceChunk.rawValue }
    
    public var coordinate: Coordinate {
        
        didSet {
            
            if oldValue != coordinate {
                
                becomeDirty()
            }
        }
    }
    
    var program: SCNProgram? { nil }
    var uniforms: [Uniform]? { nil }
    
    var textures: [Texture]? { nil }
    
    required init(coordinate: Coordinate) {
        
        self.coordinate = coordinate
        
        super.init()
        
        becomeDirty()
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
        
        position = SCNVector3(x: CGFloat(coordinate.x), y: CGFloat(Double(coordinate.y) * World.Constants.slope) + 0.5, z: CGFloat(coordinate.z))
        
        self.geometry = SCNBox(width: 1.0, height: 1.0, length: 1.0, chamferRadius: 0.0)
        self.geometry?.firstMaterial?.diffuse.contents = MDWColor.systemPurple
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
    
    public func update(delta: TimeInterval, time: TimeInterval) {
        
        //
    }
}
