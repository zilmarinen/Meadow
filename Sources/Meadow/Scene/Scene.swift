//
//  Scene.swift
//
//  Created by Zack Brown on 03/11/2020.
//

import SceneKit

public class Scene: SCNScene, Codable, Responder, SceneGraphNode, Soilable {

    private enum CodingKeys: CodingKey {
        
        case name
        case camera
        case meadow
    }
    
    public var library: MTLLibrary? {
        
        didSet {
            
            becomeDirty()
        }
    }
    
    public weak var delegate: SceneDelegate?
    
    public var ancestor: SoilableParent? { nil }
    
    public var isDirty: Bool {
        
        get {
            
            children.compactMap { $0 as? Soilable }.first { $0.isDirty } != nil
        }
        
        set {
            
            guard !isDirty, newValue else { return }
            
            for child in children {
                
                guard let child = child as? SceneGraphNode & Soilable else { continue }
                
                child.becomeDirty()
            }
        }
    }
    
    public var name: String?
    
    public var children: [SceneGraphNode] { [camera, meadow] }
    public var childCount: Int { children.count }
    public var isLeaf: Bool { children.isEmpty }
    public var category: Int { SceneGraphCategory.scene.rawValue }
    
    public let camera: Camera
    public let meadow: Meadow
    
    public var world: World {
        
        didSet {
            
            guard oldValue != world else { return }
            
            becomeDirty()
        }
    }
    
    private(set) public var lastUpdate: TimeInterval?
    
    public init(season: Season) {
        
        self.world = World(season: season)
        self.camera = Camera()
        self.meadow = Meadow()
        
        super.init()
        
        name = "Scene"
        
        camera.ancestor = self
        meadow.ancestor = self
        
        rootNode.addChildNode(camera)
        rootNode.addChildNode(meadow)
    }
    
    required public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        name = try container.decode(String.self, forKey: .name)
        camera = try container.decode(Camera.self, forKey: .camera)
        meadow = try container.decode(Meadow.self, forKey: .meadow)
        
        self.world = World(season: .spring)
        
        super.init()
        
        camera.ancestor = self
        meadow.ancestor = self
        
        rootNode.addChildNode(camera)
        rootNode.addChildNode(meadow)
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(name, forKey: .name)
        try container.encode(camera, forKey: .camera)
        try container.encode(meadow, forKey: .meadow)
    }
}

extension Scene {
    
    var scene: Scene? { self }
    
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
        
        delegate?.update(delta: delta, time: time)
        
        clean()
        
        lastUpdate = time
    }
}
