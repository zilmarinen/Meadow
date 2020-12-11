//
//  Portals.swift
//
//  Created by Zack Brown on 09/12/2020.
//

import SceneKit

public class Portals: SCNNode, Codable, Hideable, Responder, SceneGraphNode, Soilable, Updatable {
    
    private enum CodingKeys: CodingKey {
        
        case name
        case portals
    }
    
    public var ancestor: SoilableParent? { return parent as? SoilableParent }
    
    public var isDirty: Bool = false
    
    var portals: [Portal] = []
    
    public var children: [SceneGraphNode] { portals }
    public var childCount: Int { children.count }
    public var isLeaf: Bool { children.isEmpty }
    public var category: Int { SceneGraphCategory.portals.rawValue }
    
    override init() {
        
        super.init()
        
        name = "Portals"
        categoryBitMask = category
    }
    
    required public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        portals = try container.decode([Portal].self, forKey: .portals)
        
        super.init()
        
        name = try container.decode(String.self, forKey: .name)
        categoryBitMask = category
        
        for portal in portals {
            
            addChildNode(portal)
        }
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(name, forKey: .name)
        try container.encode(portals, forKey: .portals)
    }
}

extension Portals {
    
    //add
    //find
    //remove
}

extension Portals {
    
    @discardableResult public func clean() -> Bool {
        
        guard isDirty else { return false }
        
        for portal in portals {
            
            portal.clean()
        }
        
        isDirty = false
        
        return true
    }
}

extension Portals {
    
    func update(delta: TimeInterval, time: TimeInterval) {
        
        for portal in portals {
            
            portal.update(delta: delta, time: time)
        }
    }
}
