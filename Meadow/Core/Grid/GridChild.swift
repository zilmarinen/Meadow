//
//  GridChild.swift
//  Meadow-iOS
//
//  Created by Zack Brown on 20/07/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

public protocol GridChild: SceneGraphChild {
    
    var observer: GridObserver? { get }
    
    var volume: Volume { get }
}
