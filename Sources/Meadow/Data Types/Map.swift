//
//  Map.swift
//
//  Created by Zack Brown on 02/11/2020.
//

import SceneKit

public class Map: SCNNode, Decodable, Responder, Updatable {
    
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
    public let walls: Walls
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
                walls.offset = offset
                water.offset = offset
                
                becomeDirty()
            }
        }
    }
    
    public var map: Map? { self }
    
    public static func map(named identifier: String) throws -> Map? {
        
        guard let asset = NSDataAsset(name: identifier, bundle: .main) else { return nil }
        
        return try JSONDecoder().decode(Map.self, from: asset.data)
    }
    
    public override init() {
        
        actors = Actors()
        bridges = Bridges()
        buildings = Buildings()
        foliage = Foliage()
        footpath = Footpath()
        portals = Portals()
        seams = Seams()
        stairs = Stairs()
        surface = Surface()
        walls = Walls()
        water = Water()
        
        super.init()
        
        name = "Meadow"
        identifier = "meadow"
        
        addChildNode(actors)
        addChildNode(bridges)
        addChildNode(buildings)
        addChildNode(foliage)
        addChildNode(footpath)
        addChildNode(portals)
        addChildNode(seams)
        addChildNode(stairs)
        addChildNode(surface)
        addChildNode(walls)
        addChildNode(water)
        
        becomeDirty()
    }
    
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
        walls = try container.decode(Walls.self, forKey: .walls)
        water = try container.decode(Water.self, forKey: .water)
        
        super.init()
        
        name = try container.decode(String.self, forKey: .name)
        identifier = try container.decode(String.self, forKey: .identifier)
        
        addChildNode(actors)
        addChildNode(bridges)
        addChildNode(buildings)
        addChildNode(foliage)
        addChildNode(footpath)
        addChildNode(portals)
        addChildNode(seams)
        addChildNode(stairs)
        addChildNode(surface)
        addChildNode(walls)
        addChildNode(water)
        
        becomeDirty()
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
}

extension Map {
    
    @discardableResult public func clean() -> Bool {
        
        guard isDirty else { return false }
        
        actors.clean()
        bridges.clean()
        buildings.clean()
        foliage.clean()
        footpath.clean()
        portals.clean()
        seams.clean()
        stairs.clean()
        surface.clean()
        walls.clean()
        water.clean()
        
        isDirty = false
        
        return true
    }
}

extension Map {
    
    public func update(delta: TimeInterval, time: TimeInterval) {
        
        actors.update(delta: delta, time: time)
    }
}

extension Map {
    
    public func find(traversable coordinate: Coordinate) -> TraversableNode? {
     
        guard buildings.find(building: coordinate) == nil,
              foliage.find(foliage: coordinate) == nil,
              water.find(tile: coordinate)?.coordinate.y ?? 0 < coordinate.y else { return nil }
        
        if let bridge = bridges.find(tile: coordinate),
           bridge.coordinate.y == coordinate.y,
           bridge.tileType == .path {
            
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
