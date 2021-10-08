//
//  PortalSegue.swift
//
//  Created by Zack Brown on 02/05/2021.
//

public struct PortalSegue: Codable, Equatable {
    
    private enum CodingKeys: String, CodingKey {
        
        case direction = "d"
        case identifier = "i"
        case map = "m"
    }
    
    public let direction: Cardinal
    public let map: String
    public let identifier: String
    
    public init(direction: Cardinal, map: String, identifier: String) {
        
        self.direction = direction
        self.map = map
        self.identifier = identifier
    }
    
    public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        direction = try container.decode(Cardinal.self, forKey: .direction)
        identifier = try container.decode(String.self, forKey: .identifier)
        map = try container.decode(String.self, forKey: .map)
    }
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(direction, forKey: .direction)
        try container.encode(identifier, forKey: .identifier)
        try container.encode(map, forKey: .map)
    }
}
