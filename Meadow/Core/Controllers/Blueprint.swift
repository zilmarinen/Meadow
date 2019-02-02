//
//  Blueprint.swift
//  Meadow
//
//  Created by Zack Brown on 28/09/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import SceneKit

public class Blueprint: SCNNode, SceneGraphChild {
    
    public var observer: SceneGraphObserver?
    
    public var volume: Volume { return Volume(coordinate: Coordinate.zero, size: Size.one) }
    
    var isDirty: Bool = false
    
    var meshes: [Mesh] = []
}

extension Blueprint: SceneGraphUpdatable {
    
    public func update(deltaTime: TimeInterval) {
    
        clean()
    }
}

extension Blueprint: SceneGraphSoilable {
    
    public func becomeDirty() {
        
        if !isDirty {
            
            isDirty = true
        }
    }
    
    public func clean() {
        
        if !isDirty { return }
        
        self.geometry = SCNGeometry(mesh: mesh)
        
        isDirty = false
    }
}

extension Blueprint: MeshProvider {
    
    public var mesh: Mesh {
        
        return Mesh(meshes: meshes)
    }
}

extension Blueprint {
    
    public func clear() {
        
        meshes.removeAll()
        
        self.geometry = nil
        
        becomeDirty()
    }
    
    public func add(mesh: Mesh) {
        
        meshes.append(mesh)
        
        becomeDirty()
    }
}

extension Blueprint {
    
    public static let surface: MDWFloat = 0.01
}
