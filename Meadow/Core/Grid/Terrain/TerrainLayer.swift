//
//  TerrainLayer.swift
//  Meadow
//
//  Created by Zack Brown on 07/02/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

public class TerrainLayer: Layer {
    
    public struct Color {
        
        public var primary: MDWColor
        public var secondary: MDWColor
        
        public static var `default`: Color = Color(primary: .green, secondary: .brown)
        
        public init(primary: MDWColor, secondary: MDWColor) {
            
            self.primary = primary
            self.secondary = secondary
        }
    }
    
    public var color = Color.default {
        
        didSet {
            
            becomeDirty()
        }
    }
    
    public override var category: SceneGraphNodeCategory { return .terrain }
}
