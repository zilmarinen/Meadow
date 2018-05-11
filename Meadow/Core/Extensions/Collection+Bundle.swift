//
//  Collection+Bundle.swift
//  Meadow
//
//  Created by Zack Brown on 10/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Foundation

extension Collection where Iterator.Element: Bundle {
    
    /*!
     @method path:resource:type
     @abstract Search all current bundles for the specified resource.
     @param resource The filename of the resource to search for.
     @param type The file suffix of the resource to search for.
     */
    func path(forResource resource: String, ofType type: String) -> String? {
        
        for bundle in self {
            
            if let path = bundle.path(forResource: resource, ofType: type) {
                
                return path
            }
        }
        
        return nil
    }
}
