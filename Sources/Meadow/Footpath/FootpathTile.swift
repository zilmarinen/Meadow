//
//  FootpathTile.swift
//
//  Created by Zack Brown on 27/11/2020.
//

import Foundation

public class FootpathTile: NSObject, Codable, Renderable, Responder, SceneGraphNode, Soilable, Traversable, Updatable {
    
    private enum CodingKeys: CodingKey {
        
        case coordinate
        case slope
        case layer
    }
    
    enum Constants {
        
        static let slopeHeight = 0.5
        static let throneHeight = 0.5
    }
    
    public var ancestor: SoilableParent? { return chunk }
    
    public var isDirty: Bool = false
    
    weak var chunk: FootpathChunk?
    public var coordinate: Coordinate {
        
        didSet {
            
            guard oldValue.adjacency(to: coordinate) == .equal else {
                
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
    
    var neighbours: [Cardinal : FootpathTile] = [:] {
        
        didSet {
            
            becomeDirty()
        }
    }
    
    var isHidden: Bool = false
    
    public var layer: FootpathTileLayer = FootpathTileLayer(tileType: .dirt) {
        
        didSet {
            
            guard oldValue != layer else { return }
            
            becomeDirty()
        }
    }
    
    init(coordinate: Coordinate) {
        
        self.coordinate = coordinate
    }
    
    required public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        coordinate = try container.decode(Coordinate.self, forKey: .coordinate)
        layer = try container.decode(FootpathTileLayer.self, forKey: .layer)
    }
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(coordinate, forKey: .coordinate)
        try container.encode(layer, forKey: .layer)
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
    
    func find(neighbour cardinal: Cardinal) -> FootpathTile? {
        
        return neighbours[cardinal]
    }
    
    func find(neighbour ordinal: Ordinal) -> FootpathTile? {
        
        let (c0, c1) = ordinal.cardinals
        
        return find(neighbour: c0)?.find(neighbour: c1) ?? find(neighbour: c1)?.find(neighbour: c0)
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
        
        layer.tilesetTile = nil
        
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
        
        guard let slope = layer.slope else { return Array(repeating: coordinate.y, count: 4) }
        
        return Ordinal.allCases.map {
            
            let (c0, c1) = $0.cardinals
            
            return coordinate.y + (slope == c0 || slope == c1 ? 1 : 0)
        }
    }
    
    func render(position: Vector) -> [Polygon] {
        
        guard let tileUVs = layer.tilesetTile?.uvs?.uvs else { return [] }
        
        let corners = Ordinal.allCases.map { position + $0.vector + Vector(x: 0, y: 0.01, z: 0) }
        
        //
        //  Create tile apex
        //
        var apexVectors = corners.map { $0 + Vector(x: 0.0, y: Constants.slopeHeight * Double(coordinate.y), z: 0.0) }
        
        if let slope = layer.slope {
            
            let (o0, o1) = slope.ordinals
            
            apexVectors[o0.rawValue].y += Constants.slopeHeight
            apexVectors[o1.rawValue].y += Constants.slopeHeight
        }
        
        let apexNormal = apexVectors.normal()
        
        var apexVertices: [Vertex] = []
        
        for index in 0..<apexVectors.count {
            
            let corner = apexVectors[index]
            let textureCoordinates = tileUVs[index]
            
            apexVertices.append(Vertex(position: corner, normal: apexNormal, color: layer.tileType.color, textureCoordinates: textureCoordinates))
        }
        
        return [Polygon(vertices: apexVertices)]
    }
}

extension FootpathTile {
    
    func traversable(cardinal: Cardinal) -> Bool {
        
        guard let neighbour = find(neighbour: cardinal), abs(coordinate.y - neighbour.coordinate.y) <= 1 else { return false }
        
        if coordinate.y > neighbour.coordinate.y {
            
            return neighbour.layer.slope == cardinal.opposite
        }
        else if coordinate.y < neighbour.coordinate.y {
            
            return layer.slope == cardinal
        }
        
        return layer.slope == neighbour.layer.slope || ((layer.slope == nil || layer.slope == cardinal.opposite || layer.slope == neighbour.layer.slope) && (neighbour.layer.slope == nil || neighbour.layer.slope == cardinal))
    }
}

extension FootpathTile {
    
    public func set(layer tileType: FootpathTileType) {
        
        for (_, neighbour) in neighbours {
            
            if tileType != neighbour.layer.tileType {
                
                return
            }
        }
        
        self.layer.tileType = tileType
    }
}

extension FootpathTile {
    
    var seed: Int { ((coordinate.x + 1) * (coordinate.y + 2) * (coordinate.z * 4)) * 8 }
    
    func collapse() {
        
        guard let tilemap = world?.tilemaps.footpath, layer.tilesetTile == nil else { return }
        
        var rng = RNG(seed: UInt64(seed))
        
        var tiles = tilemap.tiles(with: layer.tileType)
        
        for cardinal in Cardinal.allCases.shuffled(using: &rng) {
            
            //
            //  Check edge exists
            //
            guard let neighbour = find(neighbour: cardinal) else {
                
                let rule = PatternRule()
                
                tiles = tiles.filter { $0.pattern.rule(for: cardinal).matches(rule: rule) }
                
                continue
            }
            
            //
            //  Check neighbour pattern
            //
            guard neighbour.layer.tilesetTile == nil else {
                
                let rule = neighbour.layer.tilesetTile!.pattern.rule(for: cardinal.opposite)
                
                tiles = tiles.filter { $0.pattern.rule(for: cardinal).matches(rule: rule) }
                
                continue
            }
            
            //
            //  Check layer transition
            //
            if neighbour.layer.tileType != layer.tileType {
                
                let rule = PatternRule()
                
                tiles = tiles.filter { $0.pattern.rule(for: cardinal).matches(rule: rule) }
            }
            
            //
            //  Check diagonal neighbours
            //
            let (o0, o1) = cardinal.ordinals
            let (d0, d1) = (find(neighbour: o0), find(neighbour: o1))
            
            let t0: FootpathTileType? = d0?.layer.tileType == layer.tileType ? layer.tileType : nil
            let t1: FootpathTileType? = d1?.layer.tileType == layer.tileType ? layer.tileType : nil
            
            let rule = PatternRule(left: t1?.rawValue, center: neighbour.layer.tileType.rawValue, right: t0?.rawValue)
            
            tiles = tiles.filter { $0.pattern.rule(for: cardinal).matches(rule: rule) }
        }
        
        layer.tilesetTile = tiles.randomElement(using: &rng)
    }
}
