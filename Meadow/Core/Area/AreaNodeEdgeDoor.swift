//
//  AreaNodeEdgeDoor.swift
//  Meadow
//
//  Created by Zack Brown on 27/03/2019.
//  Copyright © 2019 Script Orchard. All rights reserved.
//

public struct AreaNodeEdgeDoor: Codable, Equatable {
    
    public let colorPalette: ColorPalette
    
    public let doorType: AreaNodeEdgeDoorType
    
    public var isHidden: Bool = false
    
    public init(colorPalette: ColorPalette, doorType: AreaNodeEdgeDoorType) {
        
        self.colorPalette = colorPalette
        
        self.doorType = doorType
    }
}
