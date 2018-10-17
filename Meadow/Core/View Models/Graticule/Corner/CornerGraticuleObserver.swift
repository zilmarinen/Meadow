//
//  CornerGraticuleObserver.swift
//  Meadow
//
//  Created by Zack Brown on 17/10/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

public protocol CornerGraticuleObserver {
    
    var cornerGraticuleCallbackReference: SceneView.CornerGraticule.CallbackReference? { get }
    
    func stateDidChange(from: SceneView.CornerGraticuleState?, to: SceneView.CornerGraticuleState)
}
