//
//  Actor.swift
//
//  Created by Zack Brown on 28/03/2021.
//

import Euclid
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
    
    public var category: SceneGraphCategory { .surfaceChunk }
    
    public var coordinate: Coordinate {
        
        didSet {
            
            if oldValue != coordinate {
                
                becomeDirty()
            }
        }
    }
    
    public var direction: Cardinal = .north {
        
        didSet {
            
            if oldValue != direction {
                
                becomeDirty()
            }
        }
    }
    
    public var appearance: ActorAppearance = .default {
        
        didSet {
            
            if oldValue != appearance {
                
                becomeDirty()
            }
        }
    }
    
    public var program: SCNProgram? { nil }
    public var uniforms: [Uniform]? { nil }
    public var textures: [Texture]? { nil }
    
    lazy var model: SCNNode = {
       
        let node = SCNNode()
        
        let head = SCNNode()
        let torso = SCNNode()
        
        head.geometry = SCNBox(width: 0.2, height: 0.2, length: 0.2, chamferRadius: 0.0)
        torso.geometry = SCNBox(width: 0.2, height: 0.5, length: 0.2, chamferRadius: 0.0)
        
        head.position = SCNVector3(x: 0.0, y: 0.6, z: 0.0)
        torso.position = SCNVector3(x: 0.0, y: 0.25, z: 0.0)
        
        head.geometry?.firstMaterial?.diffuse.contents = appearance.colors.hair.color
        torso.geometry?.firstMaterial?.diffuse.contents = appearance.colors.torso.color
        
        node.addChildNode(head)
        node.addChildNode(torso)
        
        let guide = SCNNode()
        
        guide.geometry = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0.0)
        
        guide.position = SCNVector3(x: 0, y: 0.05, z: -0.5)
        
        guide.geometry?.firstMaterial?.diffuse.contents = MDWColor.systemRed
        
        node.addChildNode(guide)
        
        return node
    }()
    
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
        categoryBitMask = category.rawValue
        
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
        
        if model.parent == nil {
            
            addChildNode(model)
        }
        
        model.rotation = SCNQuaternion(Rotation(yaw: Angle(radians: Math.radians(degrees: Double(90 * direction.rawValue)))))
        
//        self.geometry = SCNBox(width: 1.0, height: 1.0, length: 1.0, chamferRadius: 0.0)
//        self.geometry?.firstMaterial?.diffuse.contents = MDWColor.systemPurple
//        self.geometry?.program = program
//
//        if let uniforms = uniforms {
//
//            self.geometry?.set(uniforms: uniforms)
//        }
//
//        if let textures = textures {
//
//            self.geometry?.set(textures: textures)
//        }
        
        isDirty = false
        
        return true
    }
    
    public func update(delta: TimeInterval, time: TimeInterval) {
        
        switch controller.state {
        
        case .idle:
            
            position = SCNVector3(Vector(x: coordinate.world.x, y: coordinate.world.y, z: coordinate.world.z))
            
        case .traversing(let path, let current, let destination):
            
            guard let index = path.nodes.firstIndex(of: current),
                  index < (path.nodes.count - 1) else {
                
                self.controller.state = .idle
                
                return
            }
            
            let next = path.nodes[index + 1]
            
            let speed = (delta / Double(current.movementCost)) * 2
            
            let currentPosition = Vector(vector: position)
            let targetPosition = next.vector
            let newPosition = currentPosition.move(towards: targetPosition, distance: speed)
            
            position = SCNVector3(newPosition)
            direction = next.direction
            
            if newPosition.compare(with: targetPosition, precision: 0.1) {
                
                coordinate = next.coordinate
                
                guard next != destination else {
                    
                    self.controller.state = .idle
                    
                    return
                }
                
                self.controller.state = .traversing(path: path, current: next, destination: destination)
            }
            
        default: break
        }
    }
}

extension Actor {
    
    func stateDidChange(from previousState: ActorState?, to currentState: ActorState) {
        
        switch currentState {
        
//        case .traversing(let path, let current, _):
//
//            print("Following path[\(path.nodes.count)]:\n\(path.nodes.first?.coordinate ?? .zero) -> \(path.nodes.last?.coordinate ?? .zero)\n\(current.coordinate) -> \(current.direction.description)")
        
        case .pathfinding(let destination):
            
            guard let scene = scene,
                  let path = scene.path(between: coordinate, destination: destination),
                  let start = path.nodes.first,
                  let end = path.nodes.last else { break }
            
            print("finding path between \(coordinate) and \(destination)")
            
            controller.state = .traversing(path: path, current: start, destination: end)
            
        case .spawn(let coordinate):
            
            print("Spawning at coordinate: \(coordinate)")
            
            self.coordinate = coordinate
            
            controller.state = .idle
        
        default: break
        }
    }
}
