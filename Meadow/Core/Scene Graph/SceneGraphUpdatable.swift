//
//  SceneGraphUpdatable.swift
//  Meadow-iOS
//
//  Created by Zack Brown on 13/09/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Foundation

public protocol SceneGraphUpdatable {
    
    func update(deltaTime: TimeInterval)
}
