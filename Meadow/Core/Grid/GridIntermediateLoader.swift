//
//  GridIntermediateLoader.swift
//  Meadow-iOS
//
//  Created by Zack Brown on 01/08/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

public protocol GridIntermediateLoader {
    
    associatedtype IntermediateType
    
    func load(nodes: [IntermediateType])
}
