//
//  SceneDelegate.swift
//  
//
//  Created by Zack Brown on 08/01/2021.
//

public protocol SceneDelegate: class, Updatable {
    
    func actor(actor: Actor, didUse portal: String)
}

public extension SceneDelegate {
    
    func actor(actor: Actor, didUse portal: String) {}
}
