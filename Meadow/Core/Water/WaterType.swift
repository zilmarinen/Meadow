//
//  WaterType.swift
//  Meadow-iOS
//
//  Created by Zack Brown on 23/07/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

public struct WaterType: GridNodeType {
    
    public let name: String

    public let colorPalette: ColorPalette
    
    var meshProvider: TerrainLayerMeshProvider {
        
        return TerrainLayerMeshProvider()
    }
    
    enum CodingKeys: String, CodingKey {
        
        case name
        case colorPalette = "color_palette"
    }
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(self.name, forKey: .name)
        try container.encode(self.colorPalette, forKey: .colorPalette)
    }
}

extension WaterType: Hashable {
    
    public var hashValue: Int { return name.hashValue }
    
    public static func == (lhs: WaterType, rhs: WaterType) -> Bool {
        
        return lhs.name == rhs.name
    }
}

