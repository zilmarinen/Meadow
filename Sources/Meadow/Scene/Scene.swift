//
//  Scene.swift
//
//  Created by Zack Brown on 03/11/2020.
//

import SceneKit

protocol SceneDelegate {
    
    func actor(actor: Actor, didMoveTo coordinate: Coordinate)
}

open class Scene: SCNScene, Codable, Responder, SceneDelegate, Soilable, Updatable {

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
    public let protagonist = Protagonist(coordinate: .zero)
    private(set) public var meadow: Meadow
    let props = Props()
    let sun = Sun()
    
    var seams: [String : Meadow] = [:]
    
    var lastUpdate: TimeInterval?
    
    public var scene: Scene? { self }
    
    public init(meadow: Meadow) {
        
        self.meadow = meadow
        
        super.init()
        
        camera.ancestor = self
        protagonist.ancestor = self
        meadow.ancestor = self
        sun.ancestor = self
        
        rootNode.addChildNode(camera)
        rootNode.addChildNode(protagonist)
        rootNode.addChildNode(meadow)
        rootNode.addChildNode(sun)
        
        camera.controller.state = .focus(node: protagonist, cardinal: .east, zoom: 0.5)
        
        updateSeams()
        
        becomeDirty()
    }
    
    required public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        meadow = try container.decode(Meadow.self, forKey: .map)
        
        super.init()
        
        camera.ancestor = self
        protagonist.ancestor = self
        meadow.ancestor = self
        sun.ancestor = self
        
        rootNode.addChildNode(camera)
        rootNode.addChildNode(protagonist)
        rootNode.addChildNode(meadow)
        rootNode.addChildNode(sun)
        
        camera.controller.state = .focus(node: protagonist, cardinal: .east, zoom: 0.5)
        
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
        
        //TODO: fix dirty scene for loading chunks
        //guard isDirty else { return false }
        
        camera.clean()
        protagonist.clean()
        meadow.clean()
        sun.clean()
        
        for (_, seam) in seams {
            
            seam.clean()
        }
        
        //isDirty = false
        
        return true
    }
}

extension Scene {
    
    public func update(delta: TimeInterval, time: TimeInterval) {
        
        camera.update(delta: delta, time: time)
        protagonist.update(delta: delta, time: time)
        meadow.update(delta: delta, time: time)
        sun.update(delta: delta, time: time)
        
        for (_, seam) in seams {
            
            seam.update(delta: delta, time: time)
        }
        
        clean()
    }
}

extension Scene: SCNSceneRendererDelegate {

    public func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        
        let delta = time - (lastUpdate ?? time)
        
        update(delta: delta, time: time)
        
        lastUpdate = time
    }
}

extension Scene {
    
    public func updateSeams() {
        
        for seam in meadow.seams.tiles {
            
            guard seams[seam.segue.scene] == nil else { continue }
            
            do {
                
                guard let adjacentMap = try load(map: seam.segue.scene),
                      let stitch = adjacentMap.seams.find(seam: seam.segue.identifier) else { continue }
                
                if adjacentMap.parent == nil {
                    
                    adjacentMap.ancestor = self
                    
                    rootNode.addChildNode(adjacentMap)
                }
                
                adjacentMap.offset = ((seam.coordinate + seam.segue.direction.coordinate) - stitch.coordinate)
                
                seams[adjacentMap.identifier] = adjacentMap
            }
            catch {
                
                fatalError("Unable to load seam: \(seam) - error: \(error)")
            }
        }
        
        let scenes = meadow.seams.tiles.map { $0.segue.scene }
        
        let detached = seams.filter { !scenes.contains($0.key) }
        
        for (_, seam) in detached {

            seam.ancestor = nil
            seam.removeFromParentNode()
        }
        
        seams = seams.filter { scenes.contains($0.key) }
    }
    
    func load(map identifier: String) throws -> Meadow? {
        
        if let seam = seams[identifier] {
            
            return seam
        }
        
        return try Meadow.map(named: identifier)
    }
    
    public func load(map meadow: Meadow) {
        
        self.meadow.ancestor = nil
        
        self.meadow = meadow
        self.meadow.ancestor = self
        
        rootNode.addChildNode(meadow)
        
        for (_, seam) in seams {
            
            seam.ancestor = nil
            seam.removeFromParentNode()
        }
    }
}

extension Scene {
    
    public func find(traversable coordinate: Coordinate) -> TraversableNode? {
        
        let maps = [meadow] + Array(seams.values)
        
        for map in maps {
            
            if let node = map.find(traversable: coordinate) {
                
                return node
            }
        }
        
        return nil
    }
    
    func path(between origin: Coordinate, destination: Coordinate) -> Path? {
        
        guard let end = find(traversable: destination),
              find(traversable: origin) != nil else { return nil }
        
        let queue = PriorityQueue<TraversableNode>()
        
        var stack: [Coordinate : TraversableNode] = [destination : end]
        var cost: [Coordinate: Double] = [destination : 0]
        
        queue.enqueue(value: end, priority: 0.0)
        
        while !queue.isEmpty {
            
            guard let node = queue.dequeue() else { return nil }
            
            guard node.value.coordinate != origin else {
                
                guard let nodes = stack.path(between: destination, destination: origin),
                      let pathNode = nodes.first else { return nil }
                
                let startNode = PathNode(coordinate: node.value.coordinate, vector: node.value.vector, direction: node.value.coordinate.direction(to: pathNode.coordinate), movementCost: node.value.movementCost, sloped: node.value.sloped)
                
                return Path(nodes: ([startNode] + nodes))
            }
            
            for cardinal in node.value.cardinals {
                
                guard let neighbour = find(traversable: node.value.coordinate + cardinal.coordinate),
                      let currentCost = cost[node.value.coordinate],
                      node.value.traversable(node: neighbour, along: cardinal) else { continue }
                
                let nodeCost = currentCost + neighbour.movementCost
                
                if stack[neighbour.coordinate] == nil || nodeCost < currentCost {
                    
                    queue.enqueue(value: neighbour, priority: currentCost + Double(origin.heuristic(coordinate: neighbour.coordinate)))
                    
                    stack[neighbour.coordinate] = node.value
                    cost[neighbour.coordinate] = nodeCost
                }
            }
        }
        
        return nil
    }
}

extension Scene {
    
    public func find(map coordinate: Coordinate) -> Meadow? {
        
        let maps = [meadow] + Array(seams.values)
        
        for map in maps {
            
            if map.find(traversable: coordinate) != nil {
                
                return map
            }
        }
        
        return nil
    }
    
    func actor(actor: Actor, didMoveTo coordinate: Coordinate) {
        
        guard actor == protagonist,
              let map = find(map: coordinate) else { return }
        
        if meadow.identifier != map.identifier {
            
            print("Moving from \(meadow.identifier) to \(map.identifier)")
            
            seams[meadow.identifier] = meadow
            
            seams.removeValue(forKey: map.identifier)
            
            meadow = map
            
            updateSeams()
        }
    }
}
