//
//  SceneKitScene.swift
//  Meadow
//
//  Created by Zack Brown on 25/04/2019.
//  Copyright © 2019 Script Orchard. All rights reserved.
//

import SceneKit

public class SceneKitScene: SCNScene, SceneGraphChild, SceneGraphObserver, SceneGraphParent {
    
    public var name: String? { return rootNode.name }
    
    public var isHidden: Bool = false
    
    public var volume: Volume { return Volume(coordinate: Coordinate.zero, size: Size.one) }
    
    public let cameraJib = SceneKitCamera()
    
    public var observer: SceneGraphObserver?
    
    public lazy var model = {
        
        return SceneKitSceneStateObserver(initialState: .empty)
    }()
    
    public init(observer: SceneGraphObserver? = nil) {
        
        self.observer = observer
        
        super.init()
        
        rootNode.name = "Meadow"
        
        rootNode.addChildNode(cameraJib)
        
        model.subscribe(stateDidChange(from:to:))
    }
    
    public required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
}

extension SceneKitScene {
    
    func stateDidChange(from: SceneState?, to: SceneState) {
        
        if let from = from {
            
            switch from {
                
            case .scene(let world):
                
                self.rootNode.name = nil
                
                world.observer = nil
                
                world.removeFromParentNode()
                
            default: break
            }
        }
        
        switch to {
            
        case .loading(let map):
            
            print("IMPLEMENT MAP LOADING")
            
            self.rootNode.name = map.name
            
            let world = World()
            
            world.load(intermediates: [map.intermediate])
            
            self.model.show(world: world)
            
        case .scene(let world):
            
            world.observer = self
            
            rootNode.addChildNode(world)
            
        default: break
        }
    }
}

extension SceneKitScene: SceneGraphUpdatable {
    
    public func update(deltaTime: TimeInterval) {
        
        guard !isPaused else { return }
        
        switch model.state {
            
        case .scene(let world):
            
            cameraJib.update(deltaTime: deltaTime)
            
            world.update(deltaTime: deltaTime)
            
        default: break
        }
    }
}

extension SceneKitScene {
    
    var children: [SCNNode] {
        
        switch model.state {
            
        case .scene: return rootNode.childNodes.compactMap { ((($0 as? SceneGraphChild) != nil) ? $0 : nil) }
            
        default: return []
        }
    }
    
    public var totalChildren: Int {
        
        switch model.state {
            
        case .scene: return children.count
            
        default: return 0
        }
    }
    
    public func child(at index: Int) -> SceneGraphChild? {
        
        switch model.state {
            
        case .scene:
            
            guard (0 ..< totalChildren).contains(index) else { return nil }
            
            return children[index] as? SceneGraphChild
            
        default: return nil
        }
    }
    
    public func index(of child: SceneGraphChild) -> Int? {
        
        switch model.state {
            
        case .scene:
         
            guard let child = child as? SCNNode else { return nil }
            
            return children.firstIndex(of: child)
            
        default: return nil
        }
    }
}

extension SceneKitScene {
    
    public func child(didBecomeDirty child: SceneGraphChild) {
        
        observer?.child(didBecomeDirty: child)
    }
}

extension SceneKitScene: Encodable {
    
    enum CodingKeys: CodingKey {
        
        case name
        
        case world
    }
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        switch model.state {
            
        case .scene(let world):
            
            try container.encodeIfPresent(self.rootNode.name, forKey: .name)
            
            try container.encode(world, forKey: .world)
            
        default: break
        }
    }
}

extension SceneKitScene {
    
    func hitTest(_ hit: SCNHitTestResult) -> SceneKitView.SceneViewHit? {
        
        switch model.state {
            
        case .scene(let world):
            
            let coordinate = Coordinate(vector: hit.worldCoordinates)
            
            let terrainNode = world.terrain.find(node: coordinate)
            
            let polytope = (terrainNode?.upperPolytope ?? Polytope(x: MDWFloat(coordinate.x), y0: World.floor, y1: World.floor, y2: World.floor, y3: World.floor, z: MDWFloat(coordinate.z)))
            
            let corner = polytope.closest(corner: hit.worldCoordinates)
            let edge = polytope.closest(edge: hit.worldCoordinates)
            
            return (coordinate, corner, edge, polytope)
            
        default: return nil
        }
    }
}
