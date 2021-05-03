//
//  PortalChunk.swift
//
//  Created by Zack Brown on 27/03/2021.
//

import SceneKit

public class PortalChunk: FootprintChunk {
    
    private enum CodingKeys: String, CodingKey {
        
        case segue = "s"
        case identifier = "i"
        case portalType = "t"
    }
    
    public let segue: PortalSegue
    let identifier: String
    let portalType: PortalType
    
    required public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        segue = try container.decode(PortalSegue.self, forKey: .segue)
        identifier = try container.decode(String.self, forKey: .identifier)
        portalType = try container.decode(PortalType.self, forKey: .portalType)
        
        try super.init(from: decoder)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func encode(to encoder: Encoder) throws {
        
        try super.encode(to: encoder)
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(segue, forKey: .segue)
        try container.encode(identifier, forKey: .identifier)
        try container.encode(portalType, forKey: .portalType)
    }
    
    public override func clean() -> Bool {
        
        guard isDirty else { return false }
        
        let size = CGSize(width: 1, height: 1)
        
        let x = CGFloat(coordinate.x) + ((size.width - 1) * 0.5)
        let z = CGFloat(coordinate.z) + ((size.height - 1) * 0.5)
        
        let height: CGFloat = 0.25
        
        position = SCNVector3(x: x, y: CGFloat(Double(coordinate.y) * World.Constants.slope) + (height / 2.0), z: z)
        
        self.geometry = SCNBox(width: size.width, height: height, length: size.height, chamferRadius: 0.0)
        self.geometry?.firstMaterial?.diffuse.contents = MDWColor.systemYellow
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
