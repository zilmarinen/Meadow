//
//  GridChunk.swift
//  Meadow
//
//  Created by Zack Brown on 26/04/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import SceneKit

public class GridChunk<Tile: GridTile<Node>, Node: GridNode>: SCNNode, SceneGraphChild, SceneGraphObserver, SceneGraphParent {
    
    public typealias ChildType = Tile
    
    public var observer: SceneGraphObserver?
    
    public var children: [ChildType] = []
    
    var isDirty: Bool = false
    
    public let volume: Volume
    
    public required init(observer: SceneGraphObserver, volume: Volume) {
        
        self.observer = observer
        
        self.volume = volume
        
        super.init()
        
        self.name = "Chunk"
        self.position = SCNVector3(x: MDWFloat(self.volume.coordinate.x), y: Axis.Y(y: self.volume.coordinate.y), z: MDWFloat(self.volume.coordinate.z))
    }
    
    public required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
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

extension GridChunk: SceneGraphSoilable {
    
    public func becomeDirty() {
        
        if !isDirty {
            
            isDirty = true
            
            observer?.child(didBecomeDirty: self)
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

extension GridChunk: SceneGraphUpdatable {
    
    public func update(deltaTime: TimeInterval) {
        
        clean()
        
        children.forEach { tile in
            
            tile.update(deltaTime: deltaTime)
        }
    }
}

extension GridChunk: MeshProvider {
    
    public var mesh: Mesh {
        
        let meshes = children.compactMap { tile -> Mesh? in
            
            return !tile.isHidden ? tile.mesh : nil
        }
        
        return Mesh(meshes: meshes)
    }
}

extension GridChunk {
    
    public func index(of child: ChildType) -> Int? {
        
        return children.index(of: child)
    }
    
    public func child(didBecomeDirty child: SceneGraphChild) {
        
        becomeDirty()
        
        observer?.child(didBecomeDirty: child)
    }
}

extension GridChunk {
    
    func add(tile volume: Volume) -> Tile? {
        
        if find(tile: volume.coordinate) != nil {
            
            return nil
        }
        
        let tile = Tile(observer: self, volume: volume)
        
        children.append(tile)
        
        becomeDirty()
        
        return tile
    }
    
    func find(tile coordinate: Coordinate) -> Tile? {
        
        return children.first { tile -> Bool in
            
            return tile.volume.coordinate.adjacency(to: coordinate) == .equal
        }
    }
    
    @discardableResult
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

extension GridChunk {
    
    static func fixedVolume(_ coordinate: Coordinate) -> Volume {
        
        let x = Int(floor(Double(coordinate.x) / Double(World.chunkSize))) * World.chunkSize
        let z = Int(floor(Double(coordinate.z) / Double(World.chunkSize))) * World.chunkSize
        
        let coordinate = Coordinate(x: x, y: World.floor, z: z)
        
        let size = Size(width: World.chunkSize, height: (World.ceiling - World.floor), depth: World.chunkSize)
        
        return Volume(coordinate: coordinate, size: size)
    }
}
