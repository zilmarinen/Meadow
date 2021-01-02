//
//  Chunk.swift
//
//  Created by Zack Brown on 23/12/2020.
//

import SceneKit

public class Chunk<T: Tile>: SCNNode, Codable, Hideable, Responder, SceneGraphNode, Shadable, Soilable, Updatable {
    
    private enum CodingKeys: CodingKey {
        
        case coordinate
        case tiles
    }
    
    public var ancestor: SoilableParent? { parent as? SoilableParent }
    
    public var isDirty: Bool {
        
        get {
            
            children.compactMap { $0 as? Soilable }.first { $0.isDirty } != nil
        }
        
        set {
            
            guard !isDirty, newValue else { return }
            
            for child in children {
                
                guard let child = child as? SceneGraphNode & Soilable else { continue }
                
                child.becomeDirty()
            }
        }
    }
    
    public let bounds: GridBounds
    var tiles: [T] = []
    
    public var children: [SceneGraphNode] { tiles }
    public var childCount: Int { children.count }
    public var isLeaf: Bool { children.isEmpty }
    public var category: Int { fatalError("Chunk.category must be overridden") }
    
    var program: SCNProgram? { nil }
    var uniforms: [Uniform]? { nil }
    var textures: [Texture]? { nil }
    
    required init(coordinate: Coordinate) {
        
        self.bounds = GridBounds(aligned: coordinate, size: World.Constants.chunkSize)
        self.tiles = []
        
        super.init()
        
        name = "Chunk \(self.bounds.start.description)"
        position = SCNVector3(coordinate: self.bounds.start)
        categoryBitMask = category
    }
    
    required public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let coordinate = try container.decode(Coordinate.self, forKey: .coordinate)
        
        bounds = GridBounds(aligned: coordinate, size: World.Constants.chunkSize)
        tiles = try container.decode([T].self, forKey: .tiles)
        
        super.init()
        
        name = "Chunk \(self.bounds.start.description)"
        position = SCNVector3(coordinate: self.bounds.start)
        categoryBitMask = category
        
        for tile in tiles {
            
            tile.ancestor = self
        }
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(bounds.start, forKey: .coordinate)
        try container.encode(tiles, forKey: .tiles)
    }
}

extension Chunk {
    
    func add(tile coordinate: Coordinate) -> T? {
        
        guard find(tile: coordinate) == nil else { return nil }
        
        let tile = T(coordinate: coordinate)
        
        tiles.append(tile)
        
        tile.ancestor = self
        
        becomeDirty()
        
        return tile
    }
    
    func find(tile coordinate: Coordinate) -> T? {
        
        return tiles.first { $0.coordinate.adjacency(to: coordinate) == .equal }
    }
    
    func remove(tile coordinate: Coordinate) {
        
        guard let index = tiles.firstIndex(where: { $0.coordinate.adjacency(to: coordinate) == .equal }) else { return }
        
        let tile = tiles[index]
        
        tile.ancestor = nil
            
        tiles.remove(at: index)
        
        becomeDirty()
    }
}

extension Chunk {
    
    @discardableResult public func clean() -> Bool {
        
        guard isDirty else { return false }
        
        var polygons: [Polygon] = []
        
        let collapsable = tiles as [Collapsable]
        
        collapsable.collapse()
        
        for tile in tiles where !tile.isHidden {
            
            tile.clean()
            
            polygons.append(contentsOf: tile.render(position: Vector(coordinate: tile.coordinate.xz - bounds.start.xz)))
        }
        
        let mesh = Mesh(polygons: polygons)
        
        self.geometry = SCNGeometry(mesh: mesh)
        self.geometry?.program = program
        
        if let uniforms = uniforms {
            
            self.geometry?.set(uniforms: uniforms)
        }
        
        if let textures = textures {
            
            self.geometry?.set(textures: textures)
        }
        
        debug(draw: false)
        
        isDirty = false
        
        return true
    }
}

extension Chunk {
    
    func update(delta: TimeInterval, time: TimeInterval) {
        
        for tile in tiles where !tile.isHidden {
            
            tile.update(delta: delta, time: time)
        }
    }
}

extension Chunk {
    
    func debug(draw traversable: Bool) {
        
        guard traversable else { return }
        
        let size = CGFloat(0.125)
        
        for node in childNodes {
            
            node.removeFromParentNode()
        }
        
        for tile in tiles {
            
            let position = Vector(coordinate: tile.coordinate.xz - bounds.start.xz)
            
            let corners = Ordinal.allCases.map { position + $0.vector }

            var vectors = corners.map { $0 + Vector(x: 0.0, y: World.Constants.slope * Double(tile.coordinate.y), z: 0.0) }
            
            if let slope = tile.slope {
                
                let (o0, o1) = slope.ordinals
                
                vectors[o0.rawValue].y += World.Constants.slope
                vectors[o1.rawValue].y += World.Constants.slope
            }
            
            let center = vectors.average()
            
            for cardinal in Cardinal.allCases {
                
                let (o0, o1) = cardinal.ordinals
                
                let (v0, v1) = (vectors[o0.rawValue], vectors[o1.rawValue])
                
                let v2 = v0.lerp(vector: v1, interpolater: 0.5)
                let v3 = v2.lerp(vector: center, interpolater: 0.5)
                
                let box = SCNBox(width: size, height: size, length: size, chamferRadius: 0.0)
                
                box.firstMaterial?.diffuse.contents = tile.traversable(cardinal: cardinal) ? MDWColor.systemGreen : MDWColor.systemRed
                
                let node = SCNNode(geometry: box)
                
                node.position = SCNVector3(vector: v3)
                
                addChildNode(node)
            }
        }
    }
}
