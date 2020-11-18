//
//  TerrainTile.swift
//
//  Created by Zack Brown on 02/11/2020.
//

import Foundation
import SceneKit

public class TerrainTile: NSObject, Codable, Renderable, Responder, SceneGraphNode, Soilable, Updatable {
    
    private enum CodingKeys: CodingKey {
        
        case coordinate
        case slope
        case tileType
    }
    
    struct Constants {
        
        static let slopeHeight = 1.0
    }
    
    struct Slope: Codable, Equatable {
        
        let cardinal: Cardinal
    }
    
    public var ancestor: SoilableParent? { return chunk }
    
    public var isDirty: Bool = false
    
    weak var chunk: TerrainChunk?
    var coordinate: Coordinate {
        
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
    public var category: Int { SceneGraphCategory.terrainTile.rawValue }
    
    var neighbours: [Cardinal : TerrainTile] = [:] {
        
        didSet {
            
            becomeDirty()
        }
    }
    
    var isHidden: Bool = false
    
    var slope: Slope? = nil {
        
        didSet {
            
            guard oldValue != slope else { return }
            
            becomeDirty()
        }
    }
    
    var tileType: TerrainTileType = .water {
        
        didSet {
            
            guard oldValue != tileType else { return }
            
            becomeDirty()
        }
    }
    
    var tile: TerrainTilesetTile? = nil
    
    init(coordinate: Coordinate) {
        
        self.coordinate = coordinate
    }
    
    required public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        coordinate = try container.decode(Coordinate.self, forKey: .coordinate)
        slope = try container.decode(Slope.self, forKey: .slope)
        tileType = try container.decode(TerrainTileType.self, forKey: .tileType)
    }
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(coordinate, forKey: .coordinate)
        try container.encode(slope, forKey: .slope)
        try container.encode(tileType, forKey: .tileType)
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
    
    func find(neighbour cardinal: Cardinal) -> TerrainTile? {
        
        return neighbours[cardinal]
    }
    
    func find(neighbour ordinal: Ordinal) -> TerrainTile? {
        
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

extension TerrainTile {
    
    @discardableResult public func clean() -> Bool {
        
        guard isDirty else { return false }
        
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
    
    func render(position: Vector) -> [Polygon] {
        
        guard let uvs = tile?.uvs else { return [] }
        
        var polygons: [Polygon] = []
        
        var corners = Ordinal.allCases.map { position + $0.vector }
        
        if let slope = slope {
            
            let (o0, o1) = slope.cardinal.ordinals
            
            corners[o0.rawValue].y += Constants.slopeHeight
            corners[o1.rawValue].y += Constants.slopeHeight
        }
        
        let normal = corners.normal()
        
        let textureCoordinates = [CGPoint(x: uvs.start.x, y: 1 - uvs.end.y),
                                  CGPoint(x: uvs.end.x, y: 1 - uvs.end.y),
                                  CGPoint(x: uvs.end.x, y: 1 - uvs.start.y),
                                  CGPoint(x: uvs.start.x, y: 1 - uvs.start.y)]
        
        var vertices: [Vertex] = []
        
        for index in 0..<corners.count {
            
            let corner = corners[index]
            let uv = textureCoordinates[index]
            
            vertices.append(Vertex(position: corner, normal: normal, color: tileType.color, textureCoordinates: uv))
        }
        
        polygons.append(Polygon(vertices: vertices.reversed()))
        
        return polygons
    }
}

extension TerrainTile {
    
    public func set(tileType: TerrainTileType) {
        
        for (_, neighbour) in neighbours {
            
            if !tileType.blends(with: neighbour.tileType) {
                
                return
            }
        }
        
        self.tileType = tileType
    }
}

extension TerrainTile {
    
    func collapse() {
        
        guard let tileset = season?.tileset else { return }
        
        var tiles = tileset.tiles(with: tileType)
        
        Cardinal.allCases.forEach { cardinal in
            
            if let neighbour = find(neighbour: cardinal) {
                
                if let rule = neighbour.tile?.pattern.rule(for: cardinal.opposite) {
                    
                    tiles = tiles.filter { $0.pattern.rule(for: cardinal).matches(rule: rule) }
                }
                else if neighbour.tileType != tileType {
                    
                    let edgeType = TerrainTileType(rawValue: max(neighbour.tileType.rawValue, tileType.rawValue))
                    
                    let rule = TerrainTileRule(left: edgeType, center: edgeType, right: edgeType)
                    
                    tiles = tiles.filter { $0.pattern.rule(for: cardinal).matches(rule: rule) }
                }
                else {
                    
                    let (o0, o1) = cardinal.ordinals
                    
                    let d0 = find(neighbour: o0)
                    let d1 = find(neighbour: o1)
                    
                    let t0 = (d0?.tileType ?? tileType).rawValue > tileType.rawValue ? d0?.tileType : nil
                    let t1 = (d1?.tileType ?? tileType).rawValue > tileType.rawValue ? d1?.tileType : nil
                    
                    let rule = TerrainTileRule(left: t1, center: nil, right: t0)
                    
                    tiles = tiles.filter { $0.pattern.rule(for: cardinal).matches(rule: rule) }
                }
            }
            else {
                
                let rule = TerrainTileRule(left: tileType, center: tileType, right: tileType)
                
                tiles = tiles.filter { $0.pattern.rule(for: cardinal).matches(rule: rule) }
            }
        }
        
        tile = tiles.last
    }
}
