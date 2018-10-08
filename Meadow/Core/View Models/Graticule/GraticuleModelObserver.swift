//
//  GraticuleModelObserver.swift
//  Meadow-iOS
//
//  Created by Zack Brown on 08/10/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

public protocol GraticuleModelObserver {
    
    var graticuleModelCallbackReference: UUID? { get }
    
    func stateDidChange(from: SceneView.GraticuleState?, to: SceneView.GraticuleState)
}
