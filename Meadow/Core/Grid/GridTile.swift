//
//  GridTile.swift
//  Meadow
//
//  Created by Zack Brown on 26/04/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Foundation

public class GridTile<Node: GridNode>: GridChild, GridParent {
    
    public typealias ChildType = Node
    
    public var observer: GridObserver?
    
    public var children: [Node] = []
    
    public var name: String? { return "Tile" }
    
    public var isHidden: Bool = false {
        
        didSet {
            
            if isHidden != oldValue {
                
                becomeDirty()
            }
        }
    }
    
    public let volume: Volume
    
    var isDirty: Bool = true
    
    public required init(observer: GridObserver, volume: Volume) {
        
        self.observer = observer
        
        self.volume = volume
    }
}

extension GridTile: GridSoilable {
    
    public func becomeDirty() {
        
        if !isDirty {
            
            isDirty = true
        }
    }
    
    public func clean() {
        
        if !isDirty { return }
        
        children.forEach { node in
            
            node.clean()
        }
        
        isDirty = false
    }
}

extension GridTile: GridUpdatable {
    
    public func update(deltaTime: TimeInterval) {
        
        clean()
        
        children.forEach { node in
            
            if let node = node as? GridUpdatable {
            
                node.update(deltaTime: deltaTime)
            }
        }
    }
}

extension GridTile: GridMeshProvider {
    
    public var mesh: Mesh {
        
        let meshes = children.compactMap { node -> Mesh? in
            
            return !node.isHidden ? node.mesh : nil
        }
        
        return Mesh(meshes: meshes)
    }
}

extension GridTile {
    
    public var totalChildren: Int { return children.count }
    
    public func child(at index: Int) -> SceneGraphChild? {
        
        return children[index]
    }
    
    public func index(of child: SceneGraphChild) -> Int? {
        
        guard let child = child as? ChildType else { return nil }
        
        return children.index(of: child)
    }
    
    public func child(didBecomeDirty child: SceneGraphChild) {
        
        let _ = becomeDirty()
        
        observer?.child(didBecomeDirty: child)
    }
}

extension GridTile {
    
    func add(node volume: Volume) -> Node? {
        
        if let _ = find(node: volume.coordinate) {
            
            return nil
        }
        
        let node = Node(observer: self, volume: volume)
        
        children.append(node)
        
        return node
    }
    
    func find(node coordinate: Coordinate) -> Node? {
        
        return children.first { node -> Bool in
            
            return node.volume.contains(coordinate: coordinate)
        }
    }
    
    func remove(node: Node) -> Bool {
        
        if let index = index(of: node) {
            
            children.remove(at: index)
            
            node.observer = nil
            
            becomeDirty()
            
            return true
        }
        
        return false
    }
}

extension GridTile: Hashable {
    
    public var hashValue: Int { return volume.hashValue }
    
    public static func == (lhs: GridTile, rhs: GridTile) -> Bool {
        
        return lhs.volume == rhs.volume
    }
}

extension GridTile: Encodable {
    
    enum CodingKeys: CodingKey {
        
        case name
        case volume
        case children
    }
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(self.name, forKey: .name)
        try container.encode(self.volume, forKey: .volume)
        try container.encode(self.children, forKey: .children)
    }
}

extension GridTile {
    
    static func fixedVolume(_ coordinate: Coordinate) -> Volume {
            
        let coordinate = Coordinate(x: coordinate.x, y: World.floor, z: coordinate.z)
        
        let size = Size(width: World.tileSize, height: (World.ceiling - World.floor), depth: World.tileSize)
        
        return Volume(coordinate: coordinate, size: size)
    }
}
