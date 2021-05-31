//
//  Meadow.swift
//
//  Created by Zack Brown on 02/11/2020.
//

import SceneKit

public class Meadow: SCNNode, Codable, Responder, Updatable {
    
    private enum CodingKeys: String, CodingKey {
        
        case actors
        case bridges
        case buildings
        case foliage
        case footpath
        case portals
        case stairs
        case surface
        case walls
        case water
        
        case name
        case identifier
    }
    
    public static var bundle: Bundle { .module }
    
    public var ancestor: SoilableParent?
    
    public var isDirty: Bool = false
    
    var identifier: String = ""
    
    let actors: Actors
    let bridges: Bridges
    let buildings: Buildings
    let foliage: Foliage
    let footpath: Footpath
    public let portals: Portals
    let stairs: Stairs
    let surface: Surface
    let water: Water
    
    var offset: Coordinate = .zero {
        
        didSet {
            
            if oldValue != offset {
                
                //TODO: offset actors
                //actors
                bridges.offset = offset
                buildings.offset = offset
                foliage.offset = offset
                footpath.offset = offset
                portals.offset = offset
                stairs.offset = offset
                surface.offset = offset
                water.offset = offset
                
                becomeDirty()
            }
        }
    }
    
    required public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        actors = try container.decode(Actors.self, forKey: .actors)
        bridges = try container.decode(Bridges.self, forKey: .bridges)
        buildings = try container.decode(Buildings.self, forKey: .buildings)
        foliage = try container.decode(Foliage.self, forKey: .foliage)
        footpath = try container.decode(Footpath.self, forKey: .footpath)
        portals = try container.decode(Portals.self, forKey: .portals)
        stairs = try container.decode(Stairs.self, forKey: .stairs)
        surface = try container.decode(Surface.self, forKey: .surface)
        water = try container.decode(Water.self, forKey: .water)
        
        super.init()
        
        name = try container.decode(String.self, forKey: .name)
        identifier  = try container.decode(String.self, forKey: .identifier)
        
        addChildNode(actors)
        addChildNode(bridges)
        addChildNode(buildings)
        addChildNode(foliage)
        addChildNode(footpath)
        addChildNode(portals)
        addChildNode(stairs)
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
        try container.encode(bridges, forKey: .bridges)
        try container.encode(buildings, forKey: .buildings)
        try container.encode(foliage, forKey: .foliage)
        try container.encode(footpath, forKey: .footpath)
        try container.encode(portals, forKey: .portals)
        try container.encode(stairs, forKey: .stairs)
        try container.encode(surface, forKey: .surface)
        try container.encode(water, forKey: .water)
        
        try container.encode(name, forKey: .name)
        try container.encode(identifier, forKey: .identifier)
    }
}

extension Meadow {
    
    @discardableResult public func clean() -> Bool {
        
        guard isDirty else { return false }
        
        actors.clean()
        bridges.clean()
        buildings.clean()
        foliage.clean()
        footpath.clean()
        portals.clean()
        stairs.clean()
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

extension Meadow {
    
    public func find(traversable coordinate: Coordinate) -> PathNode? {
     
        guard buildings.find(building: coordinate) == nil,
              foliage.find(foliage: coordinate) == nil,
              water.find(tile: coordinate) == nil else { return nil }
        
        if let bridge = bridges.find(bridge: coordinate),
           bridge.coordinate.y == coordinate.y {
            
            return bridge.pathNode(for: coordinate)
        }
        
        if let stairs = stairs.find(stairs: coordinate) {
            
            return stairs.pathNode(for: coordinate)
        }
        
        if let surface = surface.find(tile: coordinate),
           surface.walkable {
            
            return surface.pathNode(for: coordinate)
        }
            
        return nil
    }
}
