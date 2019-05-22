//
//  KeyboardObserver.swift
//  Meadow
//
//  Created by Zack Brown on 19/10/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

public protocol KeyboardObserver {
    
    var keyboardCallbackReference: SceneKitView.Keyboard.CallbackReference? { get }
    
    func stateDidChange(from: SceneKitView.KeyboardState?, to: SceneKitView.KeyboardState)
}
