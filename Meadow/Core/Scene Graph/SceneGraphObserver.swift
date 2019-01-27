//
//  SceneGraphObserver.swift
//  Meadow
//
//  Created by Zack Brown on 16/01/2019.
//  Copyright © 2019 Script Orchard. All rights reserved.
//

public protocol SceneGraphObserver {
    
    func child(didBecomeDirty child: SceneGraphChild)
}
