//
//  GraticuleObserver.swift
//  Meadow
//
//  Created by Zack Brown on 25/02/2019.
//  Copyright © 2019 Script Orchard. All rights reserved.
//

public protocol GraticuleObserver {
    
    var graticuleIdentifier: SceneView.Graticule.CallbackReference? { get }
    
    func stateDidChange(from: SceneView.GraticuleState?, to: SceneView.GraticuleState)
}
