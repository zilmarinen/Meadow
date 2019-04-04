//
//  GridTile.swift
//  Meadow
//
//  Created by Zack Brown on 26/04/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Foundation

public class GridTile<Node: GridNode>: Encodable, SceneGraphChild, SceneGraphObserver, SceneGraphParent {
    
    var children = Tree<Node>()
    
    public var observer: SceneGraphObserver?
    
    public var name: String? { return "Tile" }
    
    public var isHidden: Bool = false {
        
        didSet {
            
            if isHidden != oldValue {
                
                becomeDirty()
            }
        }
    }
    
    public let volume: Volume
    
    var isDirty: Bool = false
    
    enum CodingKeys: CodingKey {
        
        case name
        case volume
        case children
    }
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(self.name, forKey: .name)
        try container.encode(self.volume, forKey: .volume)
        try container.encode(self.children.children, forKey: .children)
    }
    
    public required init(observer: SceneGraphObserver, volume: Volume) {
        
        self.observer = observer
        
        self.volume = volume
    }
}

extension GridTile: Hashable {
    
    public static func == (lhs: GridTile, rhs: GridTile) -> Bool {
        
        return lhs.volume == rhs.volume
    }
    
    public func hash(into hasher: inout Hasher) {
        
        hasher.combine(volume)
    }
}

extension GridTile {
    
    public var totalChildren: Int { return children.count }
    
    public func child(at index: Int) -> SceneGraphChild? {
        
        return children[index]
    }
    
    public func index(of child: SceneGraphChild) -> Int? {
        
        guard let child = child as? Node else { return nil }
        
        return children.index(of: child)
    }
}

extension GridTile: SceneGraphSoilable {
    
    @discardableResult public func becomeDirty() -> Bool {
        
        if !isDirty {
            
            isDirty = true
            
            observer?.child(didBecomeDirty: self)
        }
        
        return isDirty
    }
    
    @discardableResult public func clean() -> Bool {
        
        if !isDirty { return false }
        
        children.forEach { node in
            
            node.clean()
        }
        
        isDirty = false
        
        return true
    }
}

extension GridTile: SceneGraphUpdatable {
    
    public func update(deltaTime: TimeInterval) {
        
        clean()
        
        children.forEach { node in
            
            if let node = node as? SceneGraphUpdatable {
            
                node.update(deltaTime: deltaTime)
            }
        }
    }
}

extension GridTile: MeshProvider {
    
    public var mesh: Mesh {
        
        let meshes = children.compactMap { node -> Mesh? in
            
            return !node.isHidden ? node.mesh : nil
        }
        
        return Mesh(meshes: meshes)
    }
}

extension GridTile {
    
   public func child(didBecomeDirty child: SceneGraphChild) {
        
        becomeDirty()
        
        observer?.child(didBecomeDirty: child)
    }
}

extension GridTile {
    
    func add(node volume: Volume) -> Node? {
        
        if find(node: volume.coordinate) != nil {
            
            return nil
        }
        
        let node = Node(observer: self, volume: volume)
        
        children.append(node)
        
        becomeDirty()
        
        return node
    }
    
    func find(node coordinate: Coordinate) -> Node? {
        
        return children.first { node -> Bool in
            
            return node.volume.contains(coordinate: coordinate)
        }
    }
    
    @discardableResult func remove(node: Node) -> Bool {
        
        if let index = index(of: node) {
            
            children.remove(at: index)
            
            node.observer = nil
            
            becomeDirty()
            
            return true
        }
        
        return false
    }
}

extension GridTile {
    
    static func fixedVolume(_ coordinate: Coordinate) -> Volume {
            
        let coordinate = Coordinate(x: coordinate.x, y: World.floor, z: coordinate.z)
        
        let size = Size(width: World.tileSize, height: (World.ceiling - World.floor), depth: World.tileSize)
        
        return Volume(coordinate: coordinate, size: size)
    }
}
