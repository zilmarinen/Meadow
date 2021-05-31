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
    let props = Props()
    let sun = Sun()
    
    var seams: [String : Meadow] = [:]
    
    var scene: Scene? { self }
    
    var lastUpdate: TimeInterval?
    
    public init(meadow: Meadow) {
        
        self.meadow = meadow
        
        super.init()
        
        camera.ancestor = self
        hero.ancestor = self
        meadow.ancestor = self
        sun.ancestor = self
        
        rootNode.addChildNode(camera)
        rootNode.addChildNode(hero)
        rootNode.addChildNode(meadow)
        rootNode.addChildNode(sun)
        
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
        sun.ancestor = self
        
        rootNode.addChildNode(camera)
        rootNode.addChildNode(hero)
        rootNode.addChildNode(meadow)
        rootNode.addChildNode(sun)
        
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
        sun.clean()
        
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
        sun.update(delta: delta, time: time)
        
        for (_, seam) in seams {
            
            seam.update(delta: delta, time: time)
        }
        
        clean()
        
        lastUpdate = time
    }
}

extension Scene {
    
    func updateSeams() {
        
        var newSeams: [String : Meadow] = [:]
        
        let portals = meadow.portals.find(portals: .seam)
        
        for portal in portals {
            
            do {
                
                guard let seam = try loadSeam(identifier: portal.segue.scene),
                      let wormhole = seam.portals.find(portal: portal.segue.identifier) else { continue }
                
                if seam.parent == nil {
                    
                    seam.ancestor = self
                    
                    rootNode.addChildNode(seam)
                }
                
                seam.offset = (portal.coordinate + portal.segue.direction.coordinate) - wormhole.coordinate
                
                newSeams[seam.identifier] = seam
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
    
    public func find(traversable coordinate: Coordinate) -> PathNode? {
        
        if let node = meadow.find(traversable: coordinate) {
            
            return node
        }
        
        for (_, seam) in seams {
         
            if let node = seam.find(traversable: coordinate) {
                
                return node
            }
        }
        
        return nil
    }
    
    func path(between origin: Coordinate, destination: Coordinate) -> Path? {
        
        guard let end = find(traversable: destination),
              find(traversable: origin) != nil else { return nil }
        
        let queue = PriorityQueue<PathNode>()
        
        var stack: [Coordinate : PathNode] = [destination : end]
        var cost: [Coordinate: Double] = [destination : 0]
        
        queue.enqueue(value: end, priority: 0.0)
        
        while !queue.isEmpty {
            
            guard let node = queue.dequeue() else { return nil }
            
            guard node.value.coordinate != origin else {
                
                guard let nodes = stack.path(between: destination, destination: origin) else { return nil }
                
                return Path(nodes: ([node.value] + nodes))
            }
            
            for cardinal in node.value.cardinals {
                
                guard let neighbour = find(traversable: node.value.coordinate + cardinal.coordinate),
                      neighbour.cardinals.contains(cardinal.opposite) else { continue }
                
                let incline = abs(node.value.coordinate.y - neighbour.coordinate.y)
                
                guard incline == 0 || (incline <= World.Constants.step && (node.value.sloped || neighbour.sloped)) else { continue }
                
                if stack[neighbour.coordinate] == nil || neighbour.movementCost < (cost[neighbour.coordinate] ?? Double.greatestFiniteMagnitude) {
                    
                    queue.enqueue(value: neighbour, priority: Double(origin.heuristic(coordinate: neighbour.coordinate)))
                    
                    stack[neighbour.coordinate] = node.value
                    cost[neighbour.coordinate] = neighbour.movementCost
                }
            }
        }
        
        return nil
    }
}
