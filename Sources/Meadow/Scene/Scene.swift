//
//  Scene.swift
//
//  Created by Zack Brown on 03/11/2020.
//

import SceneKit

open class Scene: SCNScene, Codable, Responder, Soilable {

    private enum CodingKeys: String, CodingKey {
        
        case map = "m"
    }
    
    public var library: MTLLibrary? {
        
        didSet {
            
            becomeDirty()
        }
    }
    
    public var ancestor: SoilableParent? { nil }
    
    public var isDirty: Bool = false
    
    public let camera = Camera()
    public let hero = Hero(coordinate: .zero)
    private(set) public var meadow: Meadow
    var seams: [String : Meadow] = [:]
    let props = Props()
    
    var scene: Scene? { self }
    
    var lastUpdate: TimeInterval?
    
    public init(meadow: Meadow) {
        
        self.meadow = meadow
        
        super.init()
        
        camera.ancestor = self
        hero.ancestor = self
        meadow.ancestor = self
        
        rootNode.addChildNode(camera)
        rootNode.addChildNode(hero)
        rootNode.addChildNode(meadow)
        
        camera.controller.state = .focus(node: hero, cardinal: .east, zoom: 1.0)
        
        updateSeams()
        
        becomeDirty()
    }
    
    required public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        meadow = try container.decode(Meadow.self, forKey: .map)
        
        super.init()
        
        camera.ancestor = self
        hero.ancestor = self
        meadow.ancestor = self
        
        rootNode.addChildNode(camera)
        rootNode.addChildNode(hero)
        rootNode.addChildNode(meadow)
        
        camera.controller.state = .focus(node: hero, cardinal: .east, zoom: 1.0)
        
        becomeDirty()
    }
    
    required public init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(meadow, forKey: .map)
    }
}

extension Scene {
    
    @discardableResult public func clean() -> Bool {
        
        guard isDirty else { return false }
        
        camera.clean()
        hero.clean()
        meadow.clean()
        
        for (_, seam) in seams {
            
            seam.clean()
        }
        
        isDirty = false
        
        return true
    }
}

extension Scene: SCNSceneRendererDelegate {

    public func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        
        let delta = time - (lastUpdate ?? time)
        
        camera.update(delta: delta, time: time)
        hero.update(delta: delta, time: time)
        meadow.update(delta: delta, time: time)
        
        for (_, seam) in seams {
            
            seam.update(delta: delta, time: time)
        }
        
        clean()
        
        lastUpdate = time
    }
}

extension Scene {
    
    func actor(actor: Actor, didMoveTo coordinate: Coordinate) {
        
        guard actor as? Hero != nil else { return }
        
        if let portal = find(seam: coordinate),
           let portals = portal.ancestor as? Portals,
           let parent = portals.ancestor as? Meadow,
           parent != meadow {
        
            print("Actor did move to new Scene!")
            seams[meadow.identifier] = meadow
            
            meadow = parent
            
            updateSeams()
        }
    }
    
    func updateSeams() {
        
        var newSeams: [String : Meadow] = [:]
        
        let portals = meadow.portals.find(portals: .seam)
        
        for portal in portals {
         
            do {
                
                guard let seam = try loadSeam(identifier: portal.segue.scene),
                      let wormhole = seam.portals.find(portal: portal.segue.identifier) else { continue }
                
                let offset = (portal.coordinate + portal.segue.direction.coordinate) - wormhole.coordinate
                
                seam.offset = offset
                seam.ancestor = self
                
                if seam.parent == nil {
                    
                    rootNode.addChildNode(seam)
                }
                
                newSeams[portal.segue.scene] = seam
            }
            catch {
                
                fatalError("Unable to load seam for portal: \(portal) - error: \(error)")
            }
        }
        
        for (identifier, seam) in seams {
            
            if newSeams[identifier] == nil {
                
                seam.ancestor = nil
                
                seam.removeFromParentNode()
            }
        }
        
        seams = newSeams
    }
    
    func loadSeam(identifier: String) throws -> Meadow? {
        
        guard let asset = NSDataAsset(name: identifier, bundle: .main) else { return nil }
        
        if let seam = seams[identifier] {
            
            return seam
        }
        
        let decoder = JSONDecoder()
        
        return try decoder.decode(Meadow.self, from: asset.data)
    }
}

extension Scene {
    
    func find(traversable coordinate: Coordinate) -> SurfaceTile? {
        
        if let tile = meadow.find(traversable: coordinate) {
            
            return tile
        }
        
        for (_, seam) in seams {
         
            if let tile = seam.find(traversable: coordinate) {
                
                return tile
            }
        }
        
        return nil
    }
    
    func find(seam coordinate: Coordinate) -> PortalChunk? {
        
        if let portal = meadow.portals.find(portal: coordinate) {
            
            return portal
        }
        
        for (_, seam) in seams {
         
            if let portal = seam.portals.find(portal: coordinate) {
                
                return portal
            }
        }
        
        return nil
    }
    
    func path(between origin: Coordinate, destination: Coordinate) -> Path? {
        
        guard let start = find(traversable: origin),
              start.walkable,
              let end = find(traversable: destination),
              end.walkable else { return nil }
        
        let queue = PriorityQueue()
                
        var stack: [Coordinate : Coordinate] = [origin : origin]
        var cost: [Coordinate: Int] = [origin : 0]
        
        queue.enqueue(coordinate: origin, priority: 0.0)
        
        while !queue.isEmpty {
            
            guard let coordinate = queue.dequeue() else { return nil }
            
            guard coordinate != destination else {
                
                guard let tile = find(traversable: coordinate) else { return nil }
                
                var nodes: [PathNode] = [tile.pathNode]
                
                var current = coordinate
                
                while current != origin {
                    
                    guard let node = stack[current],
                          let tile = find(traversable: node) else { return nil }
                    
                    nodes.append(tile.pathNode)
                    
                    current = node
                }
                
                return Path(nodes: nodes.reversed())
            }
            
            for cardinal in Cardinal.allCases {
                
                guard let neighbour = find(traversable: coordinate + cardinal.coordinate),
                      neighbour.walkable else { continue }
                
                let movementCost = neighbour.movementCost
                
                if stack[neighbour.coordinate] == nil || movementCost < (cost[neighbour.coordinate] ?? 0) {
                    
                    queue.enqueue(coordinate: neighbour.coordinate, priority: CGFloat(destination.heuristic(coordinate: neighbour.coordinate)))
                    
                    stack[neighbour.coordinate] = coordinate
                    cost[neighbour.coordinate] = movementCost
                }
            }
        }
        
        return nil
    }
}
