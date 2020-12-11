//
//  NPCs.swift
//
//  Created by Zack Brown on 10/12/2020.
//

import SceneKit

public class NPCs: SCNNode, Codable, Hideable, Responder, SceneGraphNode, Soilable, Updatable {
    
    private enum CodingKeys: CodingKey {
        
        case name
        case npcs
    }
    
    public var ancestor: SoilableParent? { parent as? SoilableParent }
    
    public var isDirty: Bool = false
    
    var npcs: [NPC] = []
    
    public var children: [SceneGraphNode] { npcs }
    public var childCount: Int { children.count }
    public var isLeaf: Bool { children.isEmpty }
    public var category: Int { SceneGraphCategory.npcs.rawValue }
    
    override init() {
        
        super.init()
        
        name = "NPCs"
        categoryBitMask = category
    }
    
    required public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        npcs = try container.decode([NPC].self, forKey: .npcs)
        
        super.init()
        
        name = try container.decode(String.self, forKey: .name)
        categoryBitMask = category
        
        for npc in npcs {
            
            addChildNode(npc)
        }
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(name, forKey: .name)
        try container.encode(npcs, forKey: .npcs)
    }
}

extension NPCs {
    
    //add
    //find
    //remove
}

extension NPCs {
    
    @discardableResult public func clean() -> Bool {
        
        guard isDirty else { return false }
        
        for npc in npcs {
            
            npc.clean()
        }
        
        isDirty = false
        
        return true
    }
}

extension NPCs {
    
    func update(delta: TimeInterval, time: TimeInterval) {
        
        for npc in npcs {
            
            npc.update(delta: delta, time: time)
        }
    }
}
