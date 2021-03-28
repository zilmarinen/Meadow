//
//  Meadow.swift
//
//  Created by Zack Brown on 02/11/2020.
//

import SceneKit

public class Meadow: SCNNode, Codable, Responder, Updatable {
    
    private enum CodingKeys: CodingKey {
        
        case actors
        case buildings
        case foliage
        case footpath
        case portals
        case surface
        case water
    }
    
    public static var bundle: Bundle { .module }
    
    public var ancestor: SoilableParent?
    
    public var isDirty: Bool = false
    
    public let actors: Actors
    let buildings: Buildings
    let foliage: Foliage
    let footpath: Footpath
    public let portals: Portals
    let surface: Surface
    let water: Water
    
    required public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        actors = try container.decode(Actors.self, forKey: .actors)
        buildings = try container.decode(Buildings.self, forKey: .buildings)
        foliage = try container.decode(Foliage.self, forKey: .foliage)
        footpath = try container.decode(Footpath.self, forKey: .footpath)
        portals = try container.decode(Portals.self, forKey: .portals)
        surface = try container.decode(Surface.self, forKey: .surface)
        water = try container.decode(Water.self, forKey: .water)
        
        super.init()
        
        addChildNode(actors)
        addChildNode(buildings)
        addChildNode(foliage)
        addChildNode(footpath)
        addChildNode(portals)
        addChildNode(surface)
        addChildNode(water)
        
        becomeDirty()
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(actors, forKey: .actors)
        try container.encode(buildings, forKey: .buildings)
        try container.encode(foliage, forKey: .foliage)
        try container.encode(footpath, forKey: .footpath)
        try container.encode(portals, forKey: .portals)
        try container.encode(surface, forKey: .surface)
        try container.encode(water, forKey: .water)
    }
}

extension Meadow {
    
    @discardableResult public func clean() -> Bool {
        
        guard isDirty else { return false }
        
        actors.clean()
        buildings.clean()
        foliage.clean()
        footpath.clean()
        portals.clean()
        surface.clean()
        water.clean()
        
        isDirty = false
        
        return true
    }
}

extension Meadow {
    
    public func update(delta: TimeInterval, time: TimeInterval) {
        
        actors.update(delta: delta, time: time)
    }
}
