//
//  CursorObserver.swift
//  Meadow
//
//  Created by Zack Brown on 02/10/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

public protocol CursorObserver {
    
    var cursorIdentifier: SceneKitView.Cursor.CallbackReference? { get }
    
    func stateDidChange(from: SceneKitView.CursorState?, to: SceneKitView.CursorState)
}
