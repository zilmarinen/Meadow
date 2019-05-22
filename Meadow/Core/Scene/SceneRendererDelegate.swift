//
//  SceneRendererDelegate.swift
//  Meadow
//
//  Created by Zack Brown on 26/04/2019.
//  Copyright © 2019 Script Orchard. All rights reserved.
//

public protocol SceneRendererDelegate {
    
    func update(deltaTime: TimeInterval, frameTime: TimeInterval)
}
