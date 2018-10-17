//
//  CursorModelObserver.swift
//  Meadow
//
//  Created by Zack Brown on 02/10/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

public protocol CursorModelObserver {
    
    var cursorModelCallbackReference: SceneView.CursorModel.CallbackReference? { get }
    
    func stateDidChange(from: SceneView.CursorState?, to: SceneView.CursorState)
}
