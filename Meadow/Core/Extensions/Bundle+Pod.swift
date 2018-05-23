//
//  Bundle+Pod.swift
//  Meadow-iOS
//
//  Created by Zack Brown on 13/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Foundation

extension Bundle {
    
    static var meadow: [Bundle] {
        
        if ProcessInfo.processInfo.environment.keys.contains("XCTestConfigurationFilePath") {
            
            return Bundle.allBundles
        }
        
        return [bundle(forPod: "Meadow")!]
    }
    
    static func bundle(forPod pod: String) -> Bundle? {
        
        let bundles = Bundle.allBundles + Bundle.allFrameworks
        
        if let path = bundles.path(forResource: pod, ofType: "bundle") {
            
            return Bundle(path: path)
        }
        
        return nil
    }
}
