//
//  Meadow.swift
//
//  Created by Zack Brown on 02/11/2020.
//

import SceneKit

public class Meadow: SCNNode, Codable, SceneGraphNode, Soilable, Updatable {
    
    private enum CodingKeys: CodingKey {
        
        case name
        case terrain
    }
    
    public struct World {
        
        let season: Season
    }
    
    public var ancestor: SoilableParent? { return parent as? SoilableParent }
    
    public var isDirty: Bool = false
    
    public var world = World(season: .spring)
    
    public let terrain: Terrain
    
    public var children: [SceneGraphNode] { [terrain] }
    public var childCount: Int { children.count }
    public var isLeaf: Bool { children.isEmpty }
    public var category: Int { SceneGraphCategory.meadow.rawValue }
    
    override init() {
        
        terrain = Terrain()
        
        super.init()
        
        name = "Meadow"
        
        addChildNode(terrain)
    }
    
    required public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        terrain = try container.decode(Terrain.self, forKey: .terrain)
        
        super.init()
        
        self.name = try container.decode(String.self, forKey: .name)
        
        addChildNode(terrain)
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(name, forKey: .name)
        try container.encode(terrain, forKey: .terrain)
    }
}

extension Meadow {
    
    @discardableResult public func clean() -> Bool {
        
        guard isDirty else { return false }
        
        terrain.clean()
        
        isDirty = false
        
        return true
    }
}

extension Meadow {
    
    func update(delta: TimeInterval, time: TimeInterval) {
        
        terrain.update(delta: delta, time: time)
    }
}

extension Meadow: Responder {
    
    var season: Season? { world.season }
}
