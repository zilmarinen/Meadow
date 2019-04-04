//
//  AreaNodeFloor.swift
//  Meadow
//
//  Created by Zack Brown on 22/03/2019.
//  Copyright © 2019 Script Orchard. All rights reserved.
//

public struct AreaNodeFloor: Codable, Equatable {
    
    public let colorPalette: ColorPalette
    
    public let floorType: AreaNodeFloorType
    
    public init(colorPalette: ColorPalette, floorType: AreaNodeFloorType) {
        
        self.colorPalette = colorPalette
        
        self.floorType = floorType
    }
}
