//
//  Actors.swift
//
//  Created by Zack Brown on 09/12/2020.
//

import SceneKit

public class Actors: SCNNode, Codable, Hideable, Responder, SceneGraphNode, Soilable, Updatable {
    
    private enum CodingKeys: CodingKey {
        
        case name
    }
    
    public var ancestor: SoilableParent? { parent as? SoilableParent }
    
    public var isDirty: Bool = true
    
    let hero = Hero()
    let npcs = NPCs()
    
    public var children: [SceneGraphNode] { [hero, npcs] }
    public var childCount: Int { children.count }
    public var isLeaf: Bool { children.isEmpty }
    public var category: Int { SceneGraphCategory.actors.rawValue }
    
    override init() {
        
        super.init()
        
        name = "Actors"
        categoryBitMask = category
        
        addChildNode(hero)
        addChildNode(npcs)
    }
    
    required public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        super.init()
        
        name = try container.decode(String.self, forKey: .name)
        categoryBitMask = category
        
        addChildNode(hero)
        addChildNode(npcs)
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(name, forKey: .name)
    }
}

extension Actors {
    
    //TODO
    //add
    //find
    //remove
}

extension Actors {
    
    @discardableResult public func clean() -> Bool {
        
        guard isDirty else { return false }
        
        hero.clean()
        npcs.clean()
        
        isDirty = false
        
        return true
    }
}

extension Actors {
    
    func update(delta: TimeInterval, time: TimeInterval) {
        
        hero.update(delta: delta, time: time)
        npcs.update(delta: delta, time: time)
    }
}
