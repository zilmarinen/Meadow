//
//  Actor.swift
//
//  Created by Zack Brown on 28/03/2021.
//

import Foundation
import SceneKit

public class Actor: SCNNode, Codable, Hideable, Responder, Shadable, Soilable, Updatable {
    
    private enum CodingKeys: String, CodingKey {
        
        case coordinate = "c"
    }
    
    public lazy var controller: ActorController = {
       
        return ActorController(initialState: .idle)
    }()
    
    public var ancestor: SoilableParent?
    
    public var isDirty: Bool = false
    
    public var category: Int { SceneGraphCategory.surfaceChunk.rawValue }
    
    public var coordinate: Coordinate {
        
        didSet {
            
            if oldValue != coordinate {
                
                becomeDirty()
            }
        }
    }
    
    var program: SCNProgram? { nil }
    var uniforms: [Uniform]? { nil }
    
    var textures: [Texture]? { nil }
    
    required init(coordinate: Coordinate) {
        
        self.coordinate = coordinate
        
        super.init()
        
        controller.subscribe(stateDidChange(from:to:))
        
        becomeDirty()
    }
    
    required public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        coordinate = try container.decode(Coordinate.self, forKey: .coordinate)
        
        super.init()
        
        name = "Chunk \(coordinate.description)"
        position = SCNVector3(coordinate: coordinate)
        categoryBitMask = category
        
        controller.subscribe(stateDidChange(from:to:))
        
        becomeDirty()
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(coordinate, forKey: .coordinate)
    }
    
    @discardableResult public func clean() -> Bool {
        
        guard isDirty else { return false }
        
        position = SCNVector3(vector: Vector(x: coordinate.world.x, y: coordinate.world.y + 0.5, z: coordinate.world.z))
        
        self.geometry = SCNBox(width: 1.0, height: 1.0, length: 1.0, chamferRadius: 0.0)
        self.geometry?.firstMaterial?.diffuse.contents = MDWColor.systemPurple
        self.geometry?.program = program
        
        if let uniforms = uniforms {
            
            self.geometry?.set(uniforms: uniforms)
        }
        
        if let textures = textures {
            
            self.geometry?.set(textures: textures)
        }
        
        isDirty = false
        
        return true
    }
    
    public func update(delta: TimeInterval, time: TimeInterval) {
        
        switch controller.state {
        
        case .moving(let path):
            
            guard let node = path.node(for: coordinate),
                  let index = path.nodes.firstIndex(of: node) else {
                
                self.controller.state = .idle
                
                return
            }
            
            guard index < (path.nodes.count - 1) else {
                
                self.controller.state = .idle
                
                return
            }
            
            let destination = path.nodes[index + 1]
            
            let currentPosition = coordinate.world
            let targetPosition = destination.coordinate.world
            let deltaPosition = Vector(vector: position)
            
            let direction = (targetPosition - currentPosition).normalised()
            
            let step = direction / Double(node.movementCost)
            
            //print("Moving from \(coordinate) to \(destination.coordinate) : \(currentPosition) -> \(targetPosition)")
            print("p: \(deltaPosition)")
            //let vector = deltaPosition.lerp(vector: targetPosition, interpolater: (1 * delta) / Double(node.movementCost))
            
            position = SCNVector3(vector: deltaPosition + (step * delta))
            
            if deltaPosition.compare(with: targetPosition) {
             
                coordinate = destination.coordinate
                
                print("-------")
                print("MOVING TO NEXT NODE")
                print("-------")
            }
            
        default: break
        }
    }
}

extension Actor {
    
    func stateDidChange(from previousState: ActorState?, to currentState: ActorState) {
        
        switch currentState {
        
        case .pathfinding(let destination):
            
            print("finding path between \(coordinate) and \(destination)")
            
            guard let path = path(between: coordinate, destination: destination) else { break }
            
            controller.state = .moving(path: path)
        
        default: break
        }
    }
}

extension Actor {
    
    func find(traversable coordinate: Coordinate) -> SurfaceTile? {
            
        guard let meadow = scene?.meadow,
              meadow.buildings.find(building: coordinate) == nil,
              meadow.foliage.find(foliage: coordinate) == nil,
              meadow.water.find(tile: coordinate) == nil else { return nil }
            
        return meadow.surface.find(tile: coordinate)
    }
    
    public func path(between origin: Coordinate, destination: Coordinate) -> Path? {
        
        guard let meadow = scene?.meadow,
              let surfaceStart = meadow.surface.find(tile: origin),
              surfaceStart.walkable,
              let surfaceEnd = meadow.surface.find(tile: destination),
              surfaceEnd.walkable else { return nil }
        
        let queue = PriorityQueue()
                
        var stack: [Coordinate : Coordinate] = [origin : origin]
        var cost: [Coordinate: Int] = [origin : 0]
        
        queue.enqueue(coordinate: origin, priority: 0.0)
        
        while !queue.isEmpty {
            
            guard let coordinate = queue.dequeue() else { return nil }
            
            guard coordinate != destination else {
                
                guard let tile = meadow.surface.find(tile: coordinate) else { return nil }
                
                var nodes: [PathNode] = [tile.pathNode]
                
                var current = coordinate
                
                while current != origin {
                    
                    guard let node = stack[current],
                          let tile = meadow.surface.find(tile: node) else { return nil }
                    
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
