//
//  Actors.swift
//
//  Created by Zack Brown on 09/12/2020.
//

import SceneKit

public class Actors: SCNNode, Codable, Hideable, Responder, SceneGraphNode, Soilable, Updatable {
    
    private enum CodingKeys: CodingKey {
        
        case name
        case actors
    }
    
    public var ancestor: SoilableParent? { return parent as? SoilableParent }
    
    public var isDirty: Bool = false
    
    var actors: [Actor] = []
    
    public var children: [SceneGraphNode] { actors }
    public var childCount: Int { children.count }
    public var isLeaf: Bool { children.isEmpty }
    public var category: Int { SceneGraphCategory.actors.rawValue }
    
    override init() {
        
        super.init()
        
        name = "Actors"
        categoryBitMask = category
    }
    
    required public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        actors = try container.decode([Actor].self, forKey: .actors)
        
        super.init()
        
        name = try container.decode(String.self, forKey: .name)
        categoryBitMask = category
        
        for actor in actors {
            
            actor.grid = self
            
            addChildNode(actor)
        }
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(name, forKey: .name)
        try container.encode(actors, forKey: .actors)
    }
}

extension Actors {
    
    //add
    //find
    //remove
}

extension Actors {
    
    @discardableResult public func clean() -> Bool {
        
        guard isDirty else { return false }
        
        for actor in actors {
            
            actor.clean()
        }
        
        isDirty = false
        
        return true
    }
}

extension Actors {
    
    func update(delta: TimeInterval, time: TimeInterval) {
        
        for actor in actors {
            
            actor.update(delta: delta, time: time)
        }
    }
}
