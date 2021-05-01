//
//  Actors.swift
//
//  Created by Zack Brown on 28/03/2021.
//

import SceneKit

public class Actors: SCNNode, Codable, Hideable, Responder, Soilable, Updatable {
    
    private enum CodingKeys: String, CodingKey {
        
        case npcs = "n"
    }
    
    public var ancestor: SoilableParent? { return parent as? SoilableParent }
    
    public var isDirty: Bool = false
    
    public var category: Int { SceneGraphCategory.surface.rawValue }
    
    let npcs: [Actor]
    
    required public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        npcs = try container.decode([Actor].self, forKey: .npcs)
        
        super.init()
        
        categoryBitMask = category
        
        for actor in npcs {
            
            actor.ancestor = self
            
            addChildNode(actor)
        }
        
        becomeDirty()
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(npcs, forKey: .npcs)
    }
}

extension Actors {
    
    func find(actor coordinate: Coordinate) -> Actor? {
        
        return npcs.first { $0.coordinate == coordinate }
    }
}

extension Actors {
    
    @discardableResult public func clean() -> Bool {
        
        guard isDirty else { return false }
        
        for actor in npcs {
            
            actor.clean()
        }
        
        isDirty = false
        
        return true
    }
}

extension Actors {
    
    public func update(delta: TimeInterval, time: TimeInterval) {
        
        for actor in npcs {
            
            actor.update(delta: delta, time: time)
        }
    }
}
