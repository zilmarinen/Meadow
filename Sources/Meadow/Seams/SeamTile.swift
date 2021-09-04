//
//  SeamTile.swift
//
//  Created by Zack Brown on 01/06/2021.
//

import SceneKit

public class SeamTile: Tile {
    
    private enum CodingKeys: String, CodingKey {
        
        case segue = "s"
        case identifier = "i"
    }
    
    public override var category: SceneGraphCategory { .seamTile }

    public let segue: PortalSegue
    let identifier: String
    
    required public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        segue = try container.decode(PortalSegue.self, forKey: .segue)
        identifier = try container.decode(String.self, forKey: .identifier)
        
        try super.init(from: decoder)
    }
    
    public override func encode(to encoder: Encoder) throws {
        
        try super.encode(to: encoder)
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(segue, forKey: .segue)
        try container.encode(identifier, forKey: .identifier)
    }
}

extension SeamTile {
    
    public static func == (lhs: SeamTile, rhs: SeamTile) -> Bool {
        
        return lhs.coordinate == rhs.coordinate && lhs.segue == rhs.segue && lhs.identifier == rhs.identifier
    }
}
