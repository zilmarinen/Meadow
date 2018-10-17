//
//  Scene.swift
//  Meadow
//
//  Created by Zack Brown on 27/04/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Foundation
import SceneKit

public class Scene: SCNScene, GridObserver, SceneGraphParent, SceneGraphChild {
    
    public var name: String? { return rootNode.name }
    
    public let world = World()
    
    public let cameraJib = CameraJib()
    
    public var observer: GridObserver?
    
    var lastUpdate: TimeInterval?
    
    public init(observer: GridObserver?) {
        
        self.observer = observer
        
        super.init()
        
        rootNode.name = "Meadow"
        
        world.observer = self
        
        rootNode.addChildNode(cameraJib)
        rootNode.addChildNode(world)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
}

extension Scene {
    
    public var totalChildren: Int { return rootNode.childNodes.count }
    
    public func child(at index: Int) -> SceneGraphChild? {
        
        return rootNode.childNodes[index] as? SceneGraphChild
    }
    
    public func index(of child: SceneGraphChild) -> Int? {
        
        guard let child = child as? SCNNode else { return nil }
        
        return rootNode.childNodes.index(of: child)
    }
    
    public func child(didBecomeDirty child: SceneGraphChild) {
        
        observer?.child(didBecomeDirty: child)
    }
}

extension Scene: SCNSceneRendererDelegate {
    
    public func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        
        let delta = time - (self.lastUpdate ?? 0)
        
        cameraJib.update(deltaTime: delta)
        
        world.update(deltaTime: delta)

        self.lastUpdate = time
    }
}

extension Scene: SceneGraphIntermediate {
    
    public func load(intermediates: [SceneIntermediate]) {
        
        guard let intermediate = intermediates.first else { return }
        
        world.load(intermediates: [intermediate.world])
    }
}

extension Scene: Encodable {
    
    enum CodingKeys: CodingKey {
        
        case name
        
        case world
    }
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encodeIfPresent(self.rootNode.name, forKey: .name)
        
        try container.encode(self.world, forKey: .world)
    }
}
