//
//  PropsIntermediate.swift
//  Meadow
//
//  Created by Zack Brown on 19/11/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

public struct PropsIntermediate: Decodable {
    
    let name: String
    
    let children: [PropIntermediate]
}
