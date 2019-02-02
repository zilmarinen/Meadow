//
//  TileGraticuleObserver.swift
//  Meadow
//
//  Created by Zack Brown on 08/10/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

public protocol TileGraticuleObserver {
    
    var tileGraticuleCallbackReference: SceneView.TileGraticule.CallbackReference? { get }
    
    func stateDidChange(from: SceneView.TileGraticuleState?, to: SceneView.TileGraticuleState)
}
