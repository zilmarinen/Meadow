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
        
        case .idle:
            
            position = SCNVector3(vector: Vector(x: coordinate.world.x, y: coordinate.world.y, z: coordinate.world.z))
        
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
            
            let speed = (delta / Double(node.movementCost)) * 2
            
            let currentPosition = Vector(vector: position)
            let targetPosition = destination.vector
            let newPosition = currentPosition.move(towards: targetPosition, distance: speed)
            
            position = SCNVector3(vector: newPosition)
            
            if newPosition.compare(with: targetPosition, precision: 0.1) {
                
                coordinate = destination.coordinate
            }
            
        default: break
        }
    }
}

extension Actor {
    
    func stateDidChange(from previousState: ActorState?, to currentState: ActorState) {
        
        switch currentState {
        
        case .moving(let path):
            
            print("Following path[\(path.nodes.count)]: \(path.nodes.first?.coordinate ?? .zero) -> \(path.nodes.last?.coordinate ?? .zero)")
        
        case .pathfinding(let destination):
            
            guard let scene = scene,
                  let path = scene.path(between: coordinate, destination: destination) else { break }
            
            print("finding path between \(coordinate) and \(destination)")
            
            controller.state = .moving(path: path)
            
        case .spawn(let coordinate):
            
            print("Spawning at coordinate: \(coordinate)")
            
            self.coordinate = coordinate
            
            controller.state = .idle
        
        default: break
        }
    }
}
