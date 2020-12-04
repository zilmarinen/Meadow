//
//  Meadow.swift
//
//  Created by Zack Brown on 02/11/2020.
//

import SceneKit

public class Meadow: SCNNode, Codable, SceneGraphNode, Soilable, Updatable {
    
    private enum CodingKeys: CodingKey {
        
        case name
        case footpath
        case terrain
    }
    
    public var ancestor: SoilableParent? { return parent as? SoilableParent }
    
    public var isDirty: Bool = false
    
    public var world: World
    
    public let footpath: Footpath
    public let terrain: Terrain
    
    public var children: [SceneGraphNode] { [footpath, terrain] }
    public var childCount: Int { children.count }
    public var isLeaf: Bool { children.isEmpty }
    public var category: Int { SceneGraphCategory.meadow.rawValue }
    
    init(season: Season) {
        
        world = World(season: season)
        
        footpath = Footpath()
        terrain = Terrain()
        
        super.init()
        
        name = "Meadow"
        
        addChildNode(footpath)
        addChildNode(terrain)
    }
    
    required public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        world = World(season: .spring)
        
        footpath = try container.decode(Footpath.self, forKey: .footpath)
        terrain = try container.decode(Terrain.self, forKey: .terrain)
        
        super.init()
        
        self.name = try container.decode(String.self, forKey: .name)
        
        addChildNode(footpath)
        addChildNode(terrain)
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(name, forKey: .name)
        try container.encode(footpath, forKey: .footpath)
        try container.encode(terrain, forKey: .terrain)
    }
}

extension Meadow {
    
    @discardableResult public func clean() -> Bool {
        
        guard isDirty else { return false }
        
        footpath.clean()
        terrain.clean()
        
        isDirty = false
        
        return true
    }
}

extension Meadow {
    
    func update(delta: TimeInterval, time: TimeInterval) {
        
        footpath.update(delta: delta, time: time)
        terrain.update(delta: delta, time: time)
    }
}

extension Meadow: Responder {
    
    var tilemaps: Tilemaps? { world.tilemaps }
}
