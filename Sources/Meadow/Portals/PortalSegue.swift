//
//  PortalSegue.swift
//
//  Created by Zack Brown on 02/05/2021.
//

public struct PortalSegue: Codable, Equatable {
    
    private enum CodingKeys: String, CodingKey {
        
        case direction = "d"
        case identifier = "i"
        case scene = "s"
    }
    
    public let direction: Cardinal
    public let scene: String
    public let identifier: String
    
    public init(direction: Cardinal, scene: String, identifier: String) {
        
        self.direction = direction
        self.scene = scene
        self.identifier = identifier
    }
    
    public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        direction = try container.decode(Cardinal.self, forKey: .direction)
        identifier = try container.decode(String.self, forKey: .identifier)
        scene = try container.decode(String.self, forKey: .scene)
    }
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(direction, forKey: .direction)
        try container.encode(identifier, forKey: .identifier)
        try container.encode(scene, forKey: .scene)
    }
}
