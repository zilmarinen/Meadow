//
//  EdgeGraticuleObserver.swift
//  Meadow
//
//  Created by Zack Brown on 17/10/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

public protocol EdgeGraticuleObserver {
    
    var edgeGraticuleCallbackReference: SceneView.EdgeGraticule.CallbackReference? { get }
    
    func stateDidChange(from: SceneView.EdgeGraticuleState?, to: SceneView.EdgeGraticuleState)
}
