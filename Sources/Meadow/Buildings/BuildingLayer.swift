//
//  BuildingLayer.swift
//
//  Created by Zack Brown on 26/01/2021.
//

public class BuildingLayer: Layer {
    
    public override var category: Int { SceneGraphCategory.buildingLayer.rawValue }
    
    public var color: Color = Color(red: 0.80, green: 0.81, blue: 0.79) {
        
        didSet {
            
            guard oldValue != color else { return }
            
            becomeDirty()
        }
    }
}
