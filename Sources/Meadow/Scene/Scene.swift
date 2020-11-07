//
//  Scene.swift
//
//  Created by Zack Brown on 03/11/2020.
//

import SceneKit

public class Scene: SCNScene, Codable, SceneGraphNode {
    
    private enum CodingKeys: CodingKey {
        
        case backgroundColor
        case name
        case meadow
    }
    
    public var backgroundColor: Color = .white
    
    public let camera = Camera()
    public let meadow: Meadow
    
    public var name: String?
    
    public var children: [SceneGraphNode] { [camera, meadow] }
    public var childCount: Int { children.count }
    public var isLeaf: Bool { children.isEmpty }
    public var category: Int { SceneGraphCategory.scene.rawValue }
    
    private var lastUpdate: TimeInterval?
    
    public override init() {
        
        self.meadow = Meadow()
        
        super.init()
        
        name = "Scene"
        
        rootNode.addChildNode(camera)
        rootNode.addChildNode(meadow)
    }
    
    required public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        backgroundColor = try container.decode(Color.self, forKey: .backgroundColor)
        name = try container.decode(String.self, forKey: .name)
        meadow = try container.decode(Meadow.self, forKey: .meadow)
        
        super.init()
        
        rootNode.addChildNode(camera)
        rootNode.addChildNode(meadow)
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(backgroundColor, forKey: .backgroundColor)
        try container.encode(name, forKey: .name)
        try container.encode(meadow, forKey: .meadow)
    }
}

extension Scene: SCNSceneRendererDelegate {

    public func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        
        let delta = time - (lastUpdate ?? time)
        
        meadow.update(delta: delta, time: time)
        
        meadow.clean()
        
        lastUpdate = time
    }
}
