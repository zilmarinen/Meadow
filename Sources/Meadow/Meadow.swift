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
        case seams
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
    
    public let actors: Actors
    public let bridges: Bridges
    public let buildings: Buildings
    public let foliage: Foliage
    public let footpath: Footpath
    public let portals: Portals
    public let seams: Seams
    public let stairs: Stairs
    public let surface: Surface
    public let water: Water
    
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
                seams.offset = offset
                stairs.offset = offset
                surface.offset = offset
                water.offset = offset
                
                becomeDirty()
            }
        }
    }
    
    public var map: Meadow? { self }
    
    required public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        actors = try container.decode(Actors.self, forKey: .actors)
        bridges = try container.decode(Bridges.self, forKey: .bridges)
        buildings = try container.decode(Buildings.self, forKey: .buildings)
        foliage = try container.decode(Foliage.self, forKey: .foliage)
        footpath = try container.decode(Footpath.self, forKey: .footpath)
        portals = try container.decode(Portals.self, forKey: .portals)
        seams = try container.decode(Seams.self, forKey: .seams)
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
        addChildNode(seams)
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
        try container.encode(seams, forKey: .seams)
        try container.encode(stairs, forKey: .stairs)
        try container.encode(surface, forKey: .surface)
        try container.encode(water, forKey: .water)
        
        try container.encode(name, forKey: .name)
        try container.encode(identifier, forKey: .identifier)
    }
}

extension Meadow {
    
    @discardableResult public func clean() -> Bool {
        
        actors.clean()
        bridges.clean()
        buildings.clean()
        foliage.clean()
        footpath.clean()
        portals.clean()
        seams.clean()
        stairs.clean()
        surface.clean()
        water.clean()
        
        return true
    }
}

extension Meadow {
    
    public func update(delta: TimeInterval, time: TimeInterval) {
        
        actors.update(delta: delta, time: time)
    }
}

extension Meadow {
    
    public func find(traversable coordinate: Coordinate) -> TraversableNode? {
     
        guard buildings.find(building: coordinate) == nil,
              foliage.find(foliage: coordinate) == nil,
              water.find(tile: coordinate)?.coordinate.y ?? 0 < coordinate.y else { return nil }
        
        if let bridge = bridges.find(bridge: coordinate),
           bridge.coordinate.y == coordinate.y {
            
            return bridge.traversableNode(for: coordinate)
        }
        
        if let stairs = stairs.find(stairs: coordinate) {
            
            return stairs.traversableNode(for: coordinate)
        }
        
        if let surface = surface.find(tile: coordinate),
           surface.walkable {
            
            return surface.traversableNode(for: coordinate)
        }
            
        return nil
    }
}
