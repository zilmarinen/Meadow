//
//  Collection+Bundle.swift
//  Meadow
//
//  Created by Zack Brown on 10/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

extension Collection where Iterator.Element: Bundle {
    
    func path(forResource resource: String, ofType type: String) -> String? {
        
        for bundle in self {
            
            if let path = bundle.path(forResource: resource, ofType: type) {
                
                return path
            }
        }
        
        return nil
    }
}
