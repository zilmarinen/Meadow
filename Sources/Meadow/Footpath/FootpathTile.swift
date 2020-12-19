//
//  FootpathTile.swift
//
//  Created by Zack Brown on 27/11/2020.
//

import Foundation

public class FootpathTile: NSObject, Codable, Collapsable, Renderable, Responder, SceneGraphNode, Soilable, Traversable, Updatable {
    
    private enum CodingKeys: CodingKey {
        
        case coordinate
        case tileType
        case slope
    }
    
    public var ancestor: SoilableParent? { return chunk }
    
    public var isDirty: Bool = false
    
    weak var chunk: FootpathChunk?
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
    public var category: Int { SceneGraphCategory.footpathTile.rawValue }
    
    public var neighbours: [Cardinal : FootpathTile] = [:] {
        
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
    
    public var tileType: FootpathTileType = .dirt {
        
        didSet {
            
            guard oldValue != tileType else { return }
            
            becomeDirty()
        }
    }
    
    public var slope: Cardinal? {
        
        didSet {
            
            guard oldValue != slope else { return }
            
            becomeDirty()
        }
    }
    
    var tilesetTile: FootpathTilesetTile? = nil
    
    init(coordinate: Coordinate) {
        
        self.coordinate = coordinate
    }
    
    required public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        coordinate = try container.decode(Coordinate.self, forKey: .coordinate)
        tileType = try container.decode(FootpathTileType.self, forKey: .tileType)
        slope = try container.decodeIfPresent(Cardinal.self, forKey: .slope)
    }
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(coordinate, forKey: .coordinate)
        try container.encode(tileType, forKey: .tileType)
        try container.encodeIfPresent(slope, forKey: .slope)
    }
}

extension FootpathTile {
    
    public static func == (lhs: FootpathTile, rhs: FootpathTile) -> Bool {
        
        return lhs.coordinate == rhs.coordinate
    }
}

extension FootpathTile {
    
    func add(neighbour: FootpathTile, cardinal: Cardinal) {
        
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
        
        if neighbour.neighbours[cardinal.opposite] != nil {
            
            neighbour.remove(neighbour: cardinal.opposite)
        }
    }
}

extension FootpathTile {
    
    @discardableResult public func clean() -> Bool {
        
        guard isDirty else { return false }
        
        tilesetTile = nil
        
        collapse()
        
        isDirty = false
        
        return true
    }
}

extension FootpathTile {
    
    func update(delta: TimeInterval, time: TimeInterval) {
        
        //
    }
}

extension FootpathTile {
    
    var cornerHeights: [Int] {
        
        guard let slope = slope else { return Array(repeating: coordinate.y, count: 4) }
        
        return Ordinal.allCases.map {
            
            let (c0, c1) = $0.cardinals
            
            return coordinate.y + (slope == c0 || slope == c1 ? 1 : 0)
        }
    }
    
    func render(position: Vector) -> [Polygon] {
        
        guard let tileUVs = tilesetTile?.uvs.uvs else { return [] }
        
        let corners = Ordinal.allCases.map { position + $0.vector + Vector(x: 0, y: 0.01, z: 0) }
        
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
        
        return [Polygon(vertices: apexVertices)]
    }
}

extension FootpathTile {
    
    var movementCost: Int { tileType.movementCost }
    var walkable: Bool { true }
    
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

extension FootpathTile {
    
    var seed: Int { ((coordinate.x + 1) * (coordinate.y + 2) * (coordinate.z + 4)) * 8 }
    
    func collapse() {
        
        guard let tilemap = meadow?.world.tilemaps.footpath, tilesetTile == nil else { return }
        
        var rng = RNG(seed: UInt64(seed))
        
        var tiles = tilemap.tiles(with: tileType)
        
        for cardinal in Cardinal.allCases.shuffled(using: &rng) {
            
            //
            //  Check edge exists and is traversable
            //
            guard let neighbour = find(neighbour: cardinal), traversable(cardinal: cardinal) else {
                
                let rule = GridPatternRule()
                
                tiles = tiles.filter { $0.pattern.rule(for: cardinal).equals(rule: rule) }
                
                continue
            }
            
            //
            //  Check neighbour pattern
            //
            guard neighbour.tilesetTile == nil else {
                
                let rule = neighbour.tilesetTile!.pattern.rule(for: cardinal.opposite)
                
                tiles = tiles.filter { $0.pattern.rule(for: cardinal).equals(rule: rule) }
                
                continue
            }
            
            //
            //  Check layer transition
            //
            if neighbour.tileType != tileType {
                
                let rule = GridPatternRule()
                
                tiles = tiles.filter { $0.pattern.rule(for: cardinal).equals(rule: rule) }
            }
            
            //
            //  Check diagonal neighbours
            //
            let (c0, c1) = cardinal.cardinals
            let (o0, o1) = cardinal.ordinals
            let (n0, n1) = (find(neighbour: c0), find(neighbour: c1))
            let (d0, d1) = (find(neighbour: o0), find(neighbour: o1))
            
            let t0: FootpathTileType? = n0 != nil && d0?.tileType == tileType ? tileType : nil
            let t1: FootpathTileType? = n1 != nil && d1?.tileType == tileType ? tileType : nil
            
            let rule = GridPatternRule(left: t1?.rawValue, center: tileType.rawValue, right: t0?.rawValue)
            
            tiles = tiles.filter { $0.pattern.rule(for: cardinal).equals(rule: rule) }
        }
        
        tilesetTile = tiles.randomElement(using: &rng)
    }
}
