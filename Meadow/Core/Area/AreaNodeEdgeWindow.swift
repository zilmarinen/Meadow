//
//  AreaNodeEdgeWindow.swift
//  Meadow
//
//  Created by Zack Brown on 27/03/2019.
//  Copyright © 2019 Script Orchard. All rights reserved.
//

public struct AreaNodeEdgeWindow: Codable, Equatable {
    
    public let colorPalette: ColorPalette
    
    public let windowType: AreaNodeEdgeWindowType
    
    public var isHidden: Bool = false
    
    public init(colorPalette: ColorPalette, windowType: AreaNodeEdgeWindowType) {
        
        self.colorPalette = colorPalette
        
        self.windowType = windowType
    }
}
