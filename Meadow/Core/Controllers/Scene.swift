//
//  Scene.swift
//  Meadow
//
//  Created by Zack Brown on 27/04/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Foundation
import SceneKit

public class Scene: SCNScene, SceneGraphChild, SceneGraphObserver, SceneGraphParent {
    
    var children = Tree<SCNNode>()
    
    public var name: String? { return rootNode.name }
    
    public var isHidden: Bool = false
    
    public var volume: Volume { return Volume(coordinate: Coordinate.zero, size: Size.one) }
    
    public let world = World()
    
    public let cameraJib = CameraJib()
    
    public var observer: SceneGraphObserver?
    
    public var delegate: SceneGraphUpdatable?
    
    var lastUpdate: TimeInterval?
    
    public init(observer: SceneGraphObserver?) {
        
        self.observer = observer
        
        super.init()
        
        rootNode.name = "Meadow"
        
        world.observer = self
        
        addChildNode(cameraJib)
        addChildNode(world)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    public func addChildNode(_ child: SCNNode) {
        
        if children.append(child) {
            
            rootNode.addChildNode(child)
        }
    }
}

extension Scene {
    
    public var totalChildren: Int { return children.count }
    
    public func child(at index: Int) -> SceneGraphChild? {
        
        return children[index] as? SceneGraphChild
    }
    
    public func index(of child: SceneGraphChild) -> Int? {
        
        guard let child = child as? SCNNode else { return nil }
        
        return children.index(of: child)
    }
}

extension Scene {
    
    public func child(didBecomeDirty child: SceneGraphChild) {
        
        observer?.child(didBecomeDirty: child)
    }
}

extension Scene: SCNSceneRendererDelegate {
    
    public func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        
        let deltaTime = time - (self.lastUpdate ?? 0)
        
        delegate?.update(deltaTime: deltaTime)
        
        cameraJib.update(deltaTime: deltaTime)
        
        world.update(deltaTime: deltaTime)

        self.lastUpdate = time
    }
}

extension Scene: SceneGraphIntermediate {
    
    public typealias IntermediateType = SceneIntermediate
    
    public func load(intermediates: [IntermediateType]) {
        
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
