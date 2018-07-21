//
//  GridNodeType.swift
//  Meadow-iOS
//
//  Created by Zack Brown on 21/07/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

public protocol GridNodeType: Codable, Hashable {
    
    var name: String { get }
}
