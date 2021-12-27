//
//  Scene.swift
//
//  Created by Zack Brown on 03/11/2020.
//

import SceneKit

protocol SceneDelegate {
    
    //
}

open class Scene: SCNScene, Responder, SceneDelegate, Soilable, Updatable {
    
    lazy var operationQueue: OperationQueue = {
            
        let queue = OperationQueue()
        
        queue.maxConcurrentOperationCount = 1
        
        return queue
    }()
    
    public var library: MTLLibrary? {
        
        didSet {
            
            becomeDirty()
        }
    }
    
    public var ancestor: SoilableParent? { nil }
    
    public var isDirty: Bool {
        
        get { !(rootNode.childNodes as? [Soilable] ?? []).filter { $0.isDirty }.isEmpty }
        set {}
    }
    
    public let camera = Camera()
    public let protagonist = Protagonist(coordinate: .zero)
    
    let sun = Sun()
    private(set) var props: Props
    
    var maps: [Map] = []
    
    var lastUpdate: TimeInterval?
    
    public var scene: Scene? { self }
    
    public required init(map: Map, props: Props) {
        
        self.maps = [map]
        self.props = props
        
        super.init()
        
        camera.ancestor = self
        protagonist.ancestor = self
        map.ancestor = self
        sun.ancestor = self
        
        rootNode.addChildNode(camera)
        rootNode.addChildNode(protagonist)
        rootNode.addChildNode(map)
        rootNode.addChildNode(sun)
        
        camera.controller.state = .focus(node: protagonist, cardinal: .north, zoom: Camera.Constants.maximumZoom)
        
        updateSeams(map: map)
    }
    
    required public init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
}

extension Scene {
    
    @discardableResult public func clean() -> Bool {
        
        guard isDirty else { return false }
        
        camera.clean()
        protagonist.clean()
        sun.clean()
        
        for map in maps {
            
            map.clean()
        }
        
        return true
    }
}

extension Scene {
    
    public func update(delta: TimeInterval, time: TimeInterval) {
        
        camera.update(delta: delta, time: time)
        protagonist.update(delta: delta, time: time)
        sun.update(delta: delta, time: time)
        
        for map in maps {
            
            map.update(delta: delta, time: time)
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
    
    public func updateSeams(map: Map) {
        
        let loadingOperation = SeamLoadingOperation(map: map, mapCache: maps, propCache: props)
        let mergingOperation = SceneMergingOperation(map: map, mapCache: maps, propCache: props)
        
        loadingOperation.passesResult(to: mergingOperation).enqueue(on: operationQueue) { result in
            
            DispatchQueue.main.async { [weak self] in
             
                guard let self = self else { return }
                
                switch result {
                    
                case .failure(let error):
                    
                    print("Error updating seams: \(error)")
                    
                case .success(let result):
                    
                    let (mergedMaps, mergedProps) = result
                    
                    for map in mergedMaps {

                        if map.parent == nil {

                            map.ancestor = self

                            self.rootNode.addChildNode(map)
                        }
                    }
                    
                    self.maps = mergedMaps
                    self.props = mergedProps
                    
                    self.becomeDirty()
                }
            }
        }
    }
}

extension Scene {
    
    public func find(traversable coordinate: Coordinate) -> TraversableNode? {
        
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
                
                let startNode = PathNode(coordinate: node.value.coordinate, position: node.value.position, direction: node.value.coordinate.direction(to: pathNode.coordinate), movementCost: node.value.movementCost, sloped: node.value.sloped)
                
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
