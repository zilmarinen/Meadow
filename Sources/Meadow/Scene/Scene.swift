//
//  Scene.swift
//
//  Created by Zack Brown on 03/11/2020.
//

import SceneKit

protocol SceneDelegate {
    
    //
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
    
    let sun = Sun()
    let props = Props()
    
    private(set) public var map: Map
    var maps: [String : Map] = [:]
    
    var lastUpdate: TimeInterval?
    
    public var scene: Scene? { self }
    
    public init(map: Map? = nil) {
        
        self.map = map ?? Map()
        
        super.init()
        
        camera.ancestor = self
        protagonist.ancestor = self
        self.map.ancestor = self
        sun.ancestor = self
        
        rootNode.addChildNode(camera)
        rootNode.addChildNode(protagonist)
        rootNode.addChildNode(self.map)
        rootNode.addChildNode(sun)
        
        let device = MTLCreateSystemDefaultDevice()

        library = try? device?.makeDefaultLibrary(bundle: Map.bundle)
        
        camera.controller.state = .focus(node: protagonist, cardinal: .east, zoom: 0.5)
        
        updateSeams()
        
        becomeDirty()
    }
    
    required public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        map = try container.decode(Map.self, forKey: .map)
        
        super.init()
        
        camera.ancestor = self
        protagonist.ancestor = self
        map.ancestor = self
        sun.ancestor = self
        
        rootNode.addChildNode(camera)
        rootNode.addChildNode(protagonist)
        rootNode.addChildNode(map)
        rootNode.addChildNode(sun)
        
        camera.controller.state = .focus(node: protagonist, cardinal: .east, zoom: 0.5)
        
        becomeDirty()
    }
    
    required public init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(map, forKey: .map)
    }
}

extension Scene {
    
    @discardableResult public func clean() -> Bool {
        
        //TODO: fix dirty scene for loading chunks
        //guard isDirty else { return false }
        
        camera.clean()
        protagonist.clean()
        map.clean()
        sun.clean()
        
        for (_, adjacent) in maps {
            
            adjacent.clean()
        }
        
        //isDirty = false
        
        return true
    }
}

extension Scene {
    
    public func update(delta: TimeInterval, time: TimeInterval) {
        
        camera.update(delta: delta, time: time)
        protagonist.update(delta: delta, time: time)
        map.update(delta: delta, time: time)
        sun.update(delta: delta, time: time)
        
        for (_, adjacent) in maps {
            
            adjacent.update(delta: delta, time: time)
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
    
    public func find(traversable coordinate: Coordinate) -> TraversableNode? {
        
        let allMaps = [map] + Array(maps.values)
        
        for map in allMaps {
            
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
    
    func clear() {
        
        self.map.ancestor = nil
        self.map.removeFromParentNode()
        
        for (_, adjacent) in maps {
            
            adjacent.ancestor = nil
            adjacent.removeFromParentNode()
        }
    }
    
    func load(map identifier: String) throws -> Map? {
        
        if let adjacent = maps[identifier] {
            
            return adjacent
        }
        
        return try Map.map(named: identifier)
    }
    
    public func load(map: Map) {
        
        clear()
        
        self.map = map
        self.map.ancestor = self
        
        rootNode.addChildNode(map)
    }
}

extension Scene {
    
    public func updateSeams() {
        
        for seam in map.seams.tiles {
            
            guard maps[seam.segue.scene] == nil else { continue }
            
            do {
                
                guard let adjacentMap = try load(map: seam.segue.scene),
                      let stitch = adjacentMap.seams.find(seam: seam.segue.identifier) else { continue }
                
                if adjacentMap.parent == nil {
                    
                    adjacentMap.ancestor = self
                    
                    rootNode.addChildNode(adjacentMap)
                }
                
                adjacentMap.offset = ((seam.coordinate + seam.segue.direction.coordinate) - stitch.coordinate)
                
                maps[adjacentMap.identifier] = adjacentMap
            }
            catch {
                
                fatalError("Unable to load seam: \(seam) - error: \(error)")
            }
        }
        
        let scenes = map.seams.tiles.map { $0.segue.scene }
        
        let detached = maps.filter { !scenes.contains($0.key) }
        
        for (_, adjacent) in detached {

            adjacent.ancestor = nil
            adjacent.removeFromParentNode()
        }
        
        maps = maps.filter { scenes.contains($0.key) }
    }
    
    public func find(map coordinate: Coordinate) -> Map? {
        
        let allMaps = [map] + Array(maps.values)
        
        for adjacent in allMaps {
            
            if adjacent.find(traversable: coordinate) != nil {
                
                return adjacent
            }
        }
        
        return nil
    }
}
