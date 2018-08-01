//
//  AreaNodeIntermediate.swift
//  Meadow-iOS
//
//  Created by Zack Brown on 20/07/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

public class AreaNodeIntermediate: GridNodeIntermediate {

    let edges: [AreaNodeEdgeIntermediate]
    
    let internalAreaType: AreaType
    let externalAreaType: AreaType
    
    let floorColorPalette: ColorPaletteIntermediate
    
    enum CodingKeys: CodingKey {
        
        case edges
        case internalAreaType
        case externalAreaType
        case floorColorPalette
    }
    
    public required init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        edges = try container.decode([AreaNodeEdgeIntermediate].self, forKey: .edges)
        
        internalAreaType = try container.decode(AreaType.self, forKey: .internalAreaType)
        externalAreaType = try container.decode(AreaType.self, forKey: .externalAreaType)
        
        floorColorPalette = try container.decode(ColorPaletteIntermediate.self, forKey: .floorColorPalette)
        
        let superDecoder = try container.superDecoder()
        
        try super.init(from: superDecoder)
    }
}
