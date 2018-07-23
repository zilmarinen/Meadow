//
//  GridChunk.swift
//  Meadow
//
//  Created by Zack Brown on 26/04/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import SceneKit

public class GridChunk<Tile: GridTile<Node>, Node: GridNode>: SCNNode, GridChild, GridParent {
    
    public typealias ChildType = Tile
    
    public var observer: GridObserver?
    
    public var children: [Tile] = []
    
    public let volume: Volume
    
    var isDirty: Bool = true
    
    public required init(observer: GridObserver, volume: Volume) {
        
        self.observer = observer
        
        self.volume = volume
        
        super.init()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
}

extension GridChunk: GridSoilable {
    
    public func becomeDirty() {
        
        if !isDirty {
            
            isDirty = true
        }
    }
    
    public func clean() {
        
        if !isDirty { return }
        
        children.forEach { tile in
            
            tile.clean()
        }
        
        self.geometry = SCNGeometry(mesh: mesh)
        
        isDirty = false
    }
}

extension GridChunk: GridUpdatable {
    
    public func update(deltaTime: TimeInterval) {
        
        clean()
        
        children.forEach { tile in
            
            tile.update(deltaTime: deltaTime)
        }
    }
}

extension GridChunk: GridMeshProvider {
    
    public var mesh: Mesh {
        
        let meshes = children.compactMap { tile -> Mesh? in
            
            return !tile.isHidden ? tile.mesh : nil
        }
        
        return Mesh(meshes: meshes)
    }
}

extension GridChunk {
    
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

extension GridChunk {
    
    func add(tile volume: Volume) -> Tile? {
        
        if let _ = find(tile: volume.coordinate) {
            
            return nil
        }
        
        let tile = Tile(observer: self, volume: volume)
        
        children.append(tile)
        
        return tile
    }
    
    func find(tile coordinate: Coordinate) -> Tile? {
        
        return children.first { tile -> Bool in
            
            return tile.volume.coordinate.adjacency(to: coordinate) == .equal
        }
    }
    
    func remove(tile: Tile) -> Bool {
        
        if let index = index(of: tile) {
            
            children.remove(at: index)
            
            tile.observer = nil
            
            becomeDirty()
            
            return true
        }
        
        return false
    }
}

extension GridChunk: Encodable {
    
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

extension GridChunk {
    
    static func fixedVolume(_ coordinate: Coordinate) -> Volume {
        
        let x = Int(floor(Double(coordinate.x) / Double(World.chunkSize))) * World.chunkSize
        let z = Int(floor(Double(coordinate.z) / Double(World.chunkSize))) * World.chunkSize
        
        let coordinate = Coordinate(x: x, y: World.floor, z: z)
        
        let size = Size(width: World.chunkSize, height: (World.ceiling - World.floor), depth: World.chunkSize)
        
        return Volume(coordinate: coordinate, size: size)
    }
}
