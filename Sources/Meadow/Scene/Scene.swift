//
//  Scene.swift
//
//  Created by Zack Brown on 03/11/2020.
//

import SceneKit

public class Scene: SCNScene, Codable, Responder, Soilable {

    private enum CodingKeys: CodingKey {
        
        case name
        case backgroundColor
        case meadow
    }
    
    public var library: MTLLibrary? {
        
        didSet {
            
            becomeDirty()
        }
    }
    
    public var ancestor: SoilableParent? { nil }
    
    public var isDirty: Bool = false
    
    public var name: String?
    
    public let camera = Camera()
    public let meadow: Meadow
    
    var scene: Scene? { self }
    
    private(set) public var lastUpdate: TimeInterval?
    
    required public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        name = try container.decode(String.self, forKey: .name)
        meadow = try container.decode(Meadow.self, forKey: .meadow)
        
        super.init()
        
        camera.ancestor = self
        meadow.ancestor = self
        
        rootNode.addChildNode(camera)
        rootNode.addChildNode(meadow)
        
        camera.controller.state = .focus(node: meadow.actors.hero, ordinal: .northEast, zoom: 1.0)
        
        becomeDirty()
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(name, forKey: .name)
        try container.encode(meadow, forKey: .meadow)
    }
}

extension Scene {
    
    public static func named(name: String) throws -> Scene? {
        
        guard let asset = NSDataAsset(name: name, bundle: .main) else { return nil }
        
        let decoder = JSONDecoder()
        
        return try decoder.decode(Scene.self, from: asset.data)
    }
}

extension Scene {
    
    @discardableResult public func clean() -> Bool {
        
        guard isDirty else { return false }
        
        camera.clean()
        meadow.clean()
        
        isDirty = false
        
        return true
    }
}

extension Scene: SCNSceneRendererDelegate {

    public func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        
        let delta = time - (lastUpdate ?? time)
        
        camera.update(delta: delta, time: time)
        meadow.update(delta: delta, time: time)
        
        clean()
        
        lastUpdate = time
    }
}
