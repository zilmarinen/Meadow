//
//  Props.swift
//
//  Created by Zack Brown on 03/05/2021.
//

import Foundation

public class Props {
    
    var buildings: [String : Model]
    var foliage: [String : Model]
    
    public init() {
        
        buildings = [:]
        foliage = [:]
    }
    
    public func prop(prop: BuildingType) -> Model {
        
        if let model = buildings[prop.identifier] {
            
            return model
        }
        
        guard let model = prop.model else { fatalError("Error loading model for prop: \(prop)") }
        
        buildings[prop.identifier] = model
        
        return model
    }
    
    public func prop(prop: FoliageType) -> Model {
        
        if let model = foliage[prop.identifier] {
            
            return model
        }
        
        guard let model = prop.model else { fatalError("Error loading model for prop: \(prop)") }
        
        foliage[prop.identifier] = model
        
        return model
    }
}
