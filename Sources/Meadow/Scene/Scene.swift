//
//  Scene.swift
//
//  Created by Zack Brown on 03/11/2020.
//

import SceneKit

public class Scene: SCNScene, Codable, SceneGraphNode, Soilable {
    
    private enum CodingKeys: CodingKey {
        
        case backgroundColor
        case name
        case meadow
    }
    
    public var ancestor: SoilableParent? { return nil }
    
    public var isDirty: Bool = false
    
    public var backgroundColor: Color = .white
    
    public let meadow: Meadow
    
    public var name: String?
    
    public var children: [SceneGraphNode] { [meadow] }
    public var childCount: Int { children.count }
    public var isLeaf: Bool { children.isEmpty }
    public var category: Int { SceneGraphCategory.scene.rawValue }
    
    private var lastUpdate: TimeInterval?
    
    public override init() {
        
        self.meadow = Meadow()
        
        super.init()
        
        name = "Scene"
        
        rootNode.addChildNode(meadow)
    }
    
    required public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        backgroundColor = try container.decode(Color.self, forKey: .backgroundColor)
        name = try container.decode(String.self, forKey: .name)
        meadow = try container.decode(Meadow.self, forKey: .meadow)
        
        super.init()
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

extension Scene {
    
    @discardableResult public func clean() -> Bool {
        
        guard isDirty else { return false }
        
        meadow.clean()
        
        return true
    }
}

extension Scene: SCNSceneRendererDelegate {

    public func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        
        let delta = time - (lastUpdate ?? time)
        
        meadow.update(delta: delta, time: time)
        
        clean()
        
        lastUpdate = time
    }
}
