//
//  AreaNodeEdgeFace.swift
//  Meadow
//
//  Created by Zack Brown on 22/03/2019.
//  Copyright © 2019 Script Orchard. All rights reserved.
//

public struct AreaNodeEdgeFace: Codable, Equatable {
    
    public let colorPalette: ColorPalette
    
    public let material: AreaNodeEdgeMaterial
    
    public init(colorPalette: ColorPalette, material: AreaNodeEdgeMaterial) {
        
        self.colorPalette = colorPalette
        
        self.material = material
    }
}
