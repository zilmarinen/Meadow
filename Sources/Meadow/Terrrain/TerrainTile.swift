//
//  TerrainTile.swift
//
//  Created by Zack Brown on 02/11/2020.
//

import Foundation
import SceneKit

public class TerrainTile: NSObject, Codable, Collapsable, Renderable, Responder, SceneGraphNode, Soilable, Traversable, Updatable {
    
    private enum CodingKeys: CodingKey {
        
        case coordinate
        case tileType
        case slope
        case tilesetTile
    }
    
    public var ancestor: SoilableParent? { return chunk }
    
    public var isDirty: Bool = false
    
    weak var chunk: TerrainChunk?
    public var coordinate: Coordinate {
        
        didSet {
            
            guard coordinate.adjacency(to: oldValue) == .equal else {
                
                coordinate = oldValue
                
                return
            }
            
            becomeDirty()
        }
    }
    
    public var name: String? { return "Tile \(coordinate.description)" }
    
    public var children: [SceneGraphNode] { [] }
    public var childCount: Int { children.count }
    public var isLeaf: Bool { children.isEmpty }
    public var category: Int { SceneGraphCategory.terrainTile.rawValue }
    
    public var neighbours: [Cardinal : TerrainTile] = [:] {
        
        didSet {
            
            becomeDirty()
        }
    }
    
    public var isHidden: Bool = false {
        
        didSet {
            
            guard oldValue != isHidden else { return }
            
            becomeDirty()
        }
    }
    
    public var tileType: TerrainTileType = .water {
        
        didSet {
            
            guard oldValue != tileType else { return }
            
            becomeDirty()
        }
    }
    
    public var slope: Cardinal? = nil {
        
        didSet {
            
            guard oldValue != slope else { return }
            
            becomeDirty()
        }
    }
    
    var tilesetTile: TerrainTilesetTile? = nil
    
    init(coordinate: Coordinate) {
        
        self.coordinate = coordinate
    }
    
    required public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        coordinate = try container.decode(Coordinate.self, forKey: .coordinate)
        tileType = try container.decode(TerrainTileType.self, forKey: .tileType)
        slope = try container.decodeIfPresent(Cardinal.self, forKey: .slope)
    }
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(coordinate, forKey: .coordinate)
        try container.encode(tileType, forKey: .tileType)
        try container.encodeIfPresent(slope, forKey: .slope)
    }
}

extension TerrainTile {
    
    public static func == (lhs: TerrainTile, rhs: TerrainTile) -> Bool {
        
        return lhs.coordinate == rhs.coordinate
    }
}

extension TerrainTile {
    
    func add(neighbour: TerrainTile, cardinal: Cardinal) {
        
        remove(neighbour: cardinal)
        
        neighbours.updateValue(neighbour, forKey: cardinal)
        
        becomeDirty()
        
        if neighbour.neighbours[cardinal.opposite] != self {
            
            neighbour.add(neighbour: self, cardinal: cardinal.opposite)
        }
    }
    
    func remove(neighbour cardinal: Cardinal) {
        
        guard let neighbour = neighbours[cardinal] else { return }
        
        neighbours.removeValue(forKey: cardinal)
        
        becomeDirty()
        
        if neighbour.neighbours[cardinal.opposite] == self {
            
            neighbour.remove(neighbour: cardinal.opposite)
        }
    }
}

extension TerrainTile {
    
    @discardableResult public func clean() -> Bool {
        
        guard isDirty else { return false }
        
        tilesetTile = nil
        
        collapse()
        
        isDirty = false
        
        return true
    }
}

extension TerrainTile {
    
    func update(delta: TimeInterval, time: TimeInterval) {
        
        //
    }
}

extension TerrainTile {
    
    var cornerHeights: [Int] {
        
        guard let slope = slope else { return Array(repeating: coordinate.y, count: 4) }
        
        return Ordinal.allCases.map {
            
            let (c0, c1) = $0.cardinals
            
            return coordinate.y + (slope == c0 || slope == c1 ? 1 : 0)
        }
    }
    
    func render(position: Vector) -> [Polygon] {
        
        guard let tileUVs = tilesetTile?.uvs.uvs else { return [] }
        
        let corners = Ordinal.allCases.map { position + $0.vector }
        
        var polygons: [Polygon] = []
        
        //
        //  Create tile apex
        //
        var apexVectors = corners.map { $0 + Vector(x: 0.0, y: World.Constants.slope * Double(coordinate.y), z: 0.0) }
        
        if let slope = slope {
            
            let (o0, o1) = slope.ordinals
            
            apexVectors[o0.rawValue].y += World.Constants.slope
            apexVectors[o1.rawValue].y += World.Constants.slope
        }
        
        let apexNormal = apexVectors.normal()
        
        var apexVertices: [Vertex] = []
        
        for index in 0..<apexVectors.count {
            
            let corner = apexVectors[index]
            let textureCoordinates = tileUVs[index]
            
            apexVertices.append(Vertex(position: corner, normal: apexNormal, color: tileType.color, textureCoordinates: textureCoordinates))
        }
        
        polygons.append(Polygon(vertices: apexVertices))
        
        guard let edges = meadow?.world.tilemaps.terrain.edgeset.edges(with: tileType) else { return polygons }
        
        var rng = RNG(seed: UInt64(seed))
        
        //
        //  Create tile edges
        //
        for cardinal in Cardinal.allCases {
            
            guard let edge = edges.randomElement(using: &rng) else { continue }
            
            let (o0, o1) = cardinal.ordinals
            
            var vertices = [Vertex(position: apexVectors[o0.rawValue], normal: cardinal.normal, color: tileType.color, textureCoordinates: edge.uvs.uvs[0]),
                            Vertex(position: apexVectors[o1.rawValue], normal: cardinal.normal, color: tileType.color, textureCoordinates: edge.uvs.uvs[1])]
            
            guard let neighbour = find(neighbour: cardinal) else {
                
                vertices.append(contentsOf: [Vertex(position: (corners[o1.rawValue] - Vector(x: 0, y: World.Constants.throne, z: 0)), normal: cardinal.normal, color: tileType.color, textureCoordinates: edge.uvs.uvs[2]),
                                             Vertex(position: (corners[o0.rawValue] - Vector(x: 0, y: World.Constants.throne, z: 0)), normal: cardinal.normal, color: tileType.color, textureCoordinates: edge.uvs.uvs[3])])
                
                polygons.append(Polygon(vertices: vertices))
                
                continue
            }
            
            let tileCorners = cornerHeights
            let neighbourCorners = neighbour.cornerHeights
            
            let (o2, o3) = cardinal.opposite.ordinals
            
            let (c0, c3) = (tileCorners[o0.rawValue], min(tileCorners[o0.rawValue], neighbourCorners[o3.rawValue]))
            let (c1, c2) = (tileCorners[o1.rawValue], min(tileCorners[o1.rawValue], neighbourCorners[o2.rawValue]))
            
            if c0 == c3 && c1 == c2 { continue }
            
            if c0 == c3 || c1 == c2 {
                
                let corner = (c0 == c3 ? o1 : o0)
                let height = (c0 == c3 ? c2 : c3)
                let uvIndex = (c0 == c3 ? 2 : 3)
                
                vertices.append(Vertex(position: (corners[corner.rawValue] + Vector(x: 0.0, y: World.Constants.slope * Double(height), z: 0.0)), normal: cardinal.normal, color: tileType.color, textureCoordinates: edge.uvs.uvs[uvIndex]))
                
                polygons.append(Polygon(vertices: vertices))
                
                continue
            }
            
            vertices.append(contentsOf: [Vertex(position: (corners[o1.rawValue] + Vector(x: 0, y: World.Constants.slope * Double(neighbourCorners[o3.rawValue]), z: 0)), normal: cardinal.normal, color: tileType.color, textureCoordinates: edge.uvs.uvs[2]),
                                         Vertex(position: (corners[o0.rawValue] - Vector(x: 0, y: World.Constants.slope * Double(neighbourCorners[o2.rawValue]), z: 0)), normal: cardinal.normal, color: tileType.color, textureCoordinates: edge.uvs.uvs[3])])
            
            polygons.append(Polygon(vertices: vertices))
        }
        
        return polygons
    }
}

extension TerrainTile {
    
    var movementCost: Int { tileType.movementCost }
    var walkable: Bool { tileType != .water }
    
    func find(neighbour cardinal: Cardinal) -> Self? {
        
        return neighbours[cardinal] as? Self
    }
    
    func find(neighbour ordinal: Ordinal) -> Self? {
        
        let (c0, c1) = ordinal.cardinals
        
        return find(neighbour: c0)?.find(neighbour: c1) ?? find(neighbour: c1)?.find(neighbour: c0)
    }
    
    func traversable(cardinal: Cardinal) -> Bool {
        
        guard let neighbour = find(neighbour: cardinal), abs(coordinate.y - neighbour.coordinate.y) <= 1 else { return false }
        
        if coordinate.y > neighbour.coordinate.y {
            
            return neighbour.slope == cardinal.opposite
        }
        else if coordinate.y < neighbour.coordinate.y {
            
            return slope == cardinal
        }
        
        return slope == neighbour.slope || ((slope == nil || slope == cardinal.opposite || slope == neighbour.slope) && (neighbour.slope == nil || neighbour.slope == cardinal))
    }
}

extension TerrainTile {
    
    var seed: Int { ((coordinate.x + 1) * (coordinate.y + 2) * (coordinate.z + 4)) * 8 }
    
    func collapse() {
        
        guard let tilemap = meadow?.world.tilemaps.terrain, tilesetTile == nil else { return }
        
        var rng = RNG(seed: UInt64(seed))
        
        var tiles = tilemap.tileset.tiles(with: tileType)
        
        for cardinal in Cardinal.allCases.shuffled(using: &rng) {
            
            //
            //  Check edge exists
            //
            guard let neighbour = find(neighbour: cardinal) else {
                
                let ruleType = tileType.rawValue
                
                let rule = GridPatternRule(left: ruleType, center: ruleType, right: ruleType)
                
                tiles = tiles.filter { $0.pattern.rule(for: cardinal).matches(rule: rule) }
                
                continue
            }
            
            //
            //  Check edge is traversable
            //
            if !traversable(cardinal: cardinal) {
                
                let ruleType = tileType.next.rawValue
                
                let rule = GridPatternRule(left: ruleType, center: ruleType, right: ruleType)
                
                tiles = tiles.filter { $0.pattern.rule(for: cardinal).matches(rule: rule) }
                
                continue
            }
            
            //
            //  Check neighbour pattern
            //
            guard neighbour.tilesetTile == nil else {
                
                let rule = neighbour.tilesetTile!.pattern.rule(for: cardinal.opposite)
                
                tiles = tiles.filter { $0.pattern.rule(for: cardinal).matches(rule: rule) }
                
                continue
            }
            
            //
            //  Check layer transition
            //
            if neighbour.tileType == tileType.next {
                
                let ruleType = tileType.next.rawValue
                
                let rule = GridPatternRule(left: ruleType, center: ruleType, right: ruleType)
                
                tiles = tiles.filter { $0.pattern.rule(for: cardinal).matches(rule: rule) }
            }
            
            //
            //  Check diagonal neighbours
            //
            let (c0, c1) = cardinal.cardinals
            let (o0, o1) = cardinal.ordinals
            let (d0, d1) = (find(neighbour: o0), find(neighbour: o1))
            
            var t0: TerrainTileType? = d0?.tileType == tileType.next ? tileType.next : nil
            var t1: TerrainTileType? = d1?.tileType == tileType.next ? tileType.next : nil
            
            if d0 != nil {
                
                t0 = !neighbour.traversable(cardinal: c0) ? tileType.next : t0
            }
            
            if d1 != nil {
                
                t1 = !neighbour.traversable(cardinal: c1) ? tileType.next : t1
            }
            
            let rule = GridPatternRule(left: t1?.rawValue, center: nil, right: t0?.rawValue)
            
            tiles = tiles.filter { $0.pattern.rule(for: cardinal).matches(rule: rule) }
        }
        
        tilesetTile = tiles.randomElement(using: &rng)
    }
}
