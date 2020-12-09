//
//  Meadow.swift
//
//  Created by Zack Brown on 02/11/2020.
//

import SceneKit

public class Meadow: SCNNode, Codable, SceneGraphNode, Soilable, Updatable {
    
    private enum CodingKeys: CodingKey {
        
        case name
        case actors
        case area
        case foliage
        case footpath
        case portals
        case props
        case terrain
    }
    
    public var ancestor: SoilableParent? { return parent as? SoilableParent }
    
    public var isDirty: Bool {
        
        get {
            
            _isDirty || area.isDirty || foliage.isDirty || footpath.isDirty || props.isDirty || terrain.isDirty
        }
        
        set {
            
            _isDirty = newValue
        }
    }
    
    var _isDirty: Bool = false
    
    public var world: World
    
    public let actors: Actors
    public let area: Area
    public let foliage: Foliage
    public let footpath: Footpath
    public let portals: Portals
    public let props: Props
    public let terrain: Terrain
    
    public var children: [SceneGraphNode] { [actors, area, foliage, footpath, portals, props, terrain] }
    public var childCount: Int { children.count }
    public var isLeaf: Bool { children.isEmpty }
    public var category: Int { SceneGraphCategory.meadow.rawValue }
    
    init(season: Season) {
        
        world = World(season: season)
        
        actors = Actors()
        area = Area()
        foliage = Foliage()
        footpath = Footpath()
        portals = Portals()
        props = Props()
        terrain = Terrain()
        
        super.init()
        
        name = "Meadow"
        
        addChildNode(actors)
        addChildNode(area)
        addChildNode(foliage)
        addChildNode(footpath)
        addChildNode(portals)
        addChildNode(props)
        addChildNode(terrain)
    }
    
    required public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        world = World(season: .spring)
        
        actors = try container.decode(Actors.self, forKey: .actors)
        area = try container.decode(Area.self, forKey: .area)
        foliage = try container.decode(Foliage.self, forKey: .foliage)
        footpath = try container.decode(Footpath.self, forKey: .footpath)
        portals = try container.decode(Portals.self, forKey: .portals)
        props = try container.decode(Props.self, forKey: .props)
        terrain = try container.decode(Terrain.self, forKey: .terrain)
        
        super.init()
        
        self.name = try container.decode(String.self, forKey: .name)
        
        addChildNode(actors)
        addChildNode(area)
        addChildNode(foliage)
        addChildNode(footpath)
        addChildNode(portals)
        addChildNode(props)
        addChildNode(terrain)
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(name, forKey: .name)
        try container.encode(portals, forKey: .portals)
        try container.encode(area, forKey: .area)
        try container.encode(foliage, forKey: .foliage)
        try container.encode(footpath, forKey: .footpath)
        try container.encode(props, forKey: .props)
        try container.encode(terrain, forKey: .terrain)
    }
}

extension Meadow {
    
    @discardableResult public func clean() -> Bool {
        
        guard isDirty else { return false }
        
        actors.clean()
        area.clean()
        foliage.clean()
        footpath.clean()
        portals.clean()
        props.clean()
        terrain.clean()
        
        isDirty = false
        
        return true
    }
}

extension Meadow {
    
    func update(delta: TimeInterval, time: TimeInterval) {
        
        actors.update(delta: delta, time: time)
        area.update(delta: delta, time: time)
        foliage.update(delta: delta, time: time)
        footpath.update(delta: delta, time: time)
        portals.update(delta: delta, time: time)
        props.update(delta: delta, time: time)
        terrain.update(delta: delta, time: time)
    }
}

extension Meadow: Responder {
    
    var tilemaps: Tilemaps? { world.tilemaps }
}

extension Meadow {
    
    func path(between origin: GridNode, destination: GridNode) -> Path? {
        
        guard origin != destination,
              let start = find(traversable: origin),
              let end = find(traversable: destination),
              start.walkable,
              end.walkable else { return nil }
        
        let queue = PriorityQueue()
        
        var stack: [GridNode : GridNode] = [origin : origin]
        var cost: [GridNode: Int] = [origin : 0]
        
        queue.enqueue(gridNode: origin, priority: 0.0)
        
        while !queue.isEmpty {
            
            guard let node = queue.dequeue(),
                  let traversable = find(traversable: node) else { return nil }
            
            if node == destination {
                
                var nodes: [GridNode] = [node]
                
                while node != origin {
                    
                    guard let node = stack[node] else { return nil }
                    
                    nodes.append(node)
                }
                
                return Path(nodes: nodes.reversed())
            }
            
            let (c0, c1) = node.cardinal.cardinals
            
            for cardinal in [c0, c1] {
                
                let tileNode = GridNode(coordinate: node.coordinate, cardinal: cardinal)
                
                if stack[tileNode] == nil {
                    
                    stack[tileNode] = node
                    cost[tileNode] = traversable.movementCost
                    
                    queue.enqueue(gridNode: tileNode, priority: 0.0)
                }
            }
            
            if let neighbour = traversable.find(neighbour: node.cardinal), neighbour.walkable {
                
                let coordinate = node.coordinate + node.cardinal.coordinate
                
                let tileNode = GridNode(coordinate: coordinate, cardinal: node.cardinal.opposite)
                
                let movementCost = neighbour.movementCost
                
                if stack[tileNode] == nil || movementCost < (cost[tileNode] ?? 0) {
                    
                    stack[tileNode] = node
                    cost[tileNode] = movementCost + node.cardinal.coordinate.x + node.cardinal.coordinate.z
                }
            }
        }
        
        return nil
    }
    
    func find(traversable node: GridNode) -> Traversable? {
        
        guard foliage.find(tile: node.coordinate) == nil,
              props.find(prop: node) == nil else { return nil }
        
        return  area.find(tile: node.coordinate) ??
                footpath.find(tile: node.coordinate) ??
                terrain.find(tile: node.coordinate)
    }
}
