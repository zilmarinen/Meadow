//
//  SceneGraphIntermediate.swift
//  Meadow
//
//  Created by Zack Brown on 16/09/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

protocol SceneGraphIntermediate {
    
    associatedtype IntermediateType
    
    func load(intermediates: [IntermediateType])
}
