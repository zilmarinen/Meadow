//
//  SceneGraphChild.swift
//  Meadow
//
//  Created by Zack Brown on 20/07/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

public protocol SceneGraphChild {
    
    var observer: SceneGraphObserver? { get }
    
    var name: String? { get }
    
    var isHidden: Bool { get }
    
    var volume: Volume { get }
}
