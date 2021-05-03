//
//  Props.swift
//
//  Created by Zack Brown on 03/05/2021.
//

import Foundation

public class Props {
    
    var props: [String : Model]
    
    public init() {
        
        props = [:]
    }
    
    public func prop(foliage: FoliageType) -> Model {
        
        if let model = props[foliage.identifier] {
            
            return model
        }
        
        guard let model = foliage.model else { fatalError("Error loading model for prop: \(foliage)") }
        
        props[foliage.identifier] = model
        
        return model
    }
}
