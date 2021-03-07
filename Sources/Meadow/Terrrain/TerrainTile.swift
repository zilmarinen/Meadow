//
//  TerrainTile.swift
//
//  Created by Zack Brown on 02/11/2020.
//

import Foundation

public class TerrainTile: Tile {
    
    enum Constants {
        
        static let throne = World.Constants.slope
    }
    
    enum CodingKeys: CodingKey {
        
        case tileType
    }
    
    public override var category: Int { SceneGraphCategory.terrainTile.rawValue }
    override var movementCost: Int { tileType.movementCost }
    override var walkable: Bool { tileType != .water }
    
    public var tileType: TerrainTileType = .sand {
        
        didSet {
            
            guard oldValue != tileType else { return }
            
            invalidate(neighbours: true)
        }
    }
    
    var tilesetTile: TerrainTilesetTile?
    
    public required init(from decoder: Decoder) throws {
        
        try super.init(from: decoder)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        tileType = try container.decode(TerrainTileType.self, forKey: .tileType)
    }
    
    required init(coordinate: Coordinate) {
        
        super.init(coordinate: coordinate)
    }
    
    public override func encode(to encoder: Encoder) throws {
        
        try super.encode(to: encoder)
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(tileType, forKey: .tileType)
    }
    
    override func invalidate(neighbours: Bool) {
        
        tilesetTile = nil
        
        super.invalidate(neighbours: neighbours)
    }
    
    public override func update(delta: TimeInterval, time: TimeInterval) {
        
        //
    }
    
    override func traversable(cardinal: Cardinal) -> Bool {
        
        guard let neighbour = find(neighbour: cardinal), abs(coordinate.y - neighbour.coordinate.y) <= 1 else { return false }
        
        if coordinate.y > neighbour.coordinate.y {
            
            return neighbour.slope == cardinal.opposite
        }
        else if coordinate.y < neighbour.coordinate.y {
            
            return slope == cardinal
        }
        
        return slope == neighbour.slope || ((slope == nil || slope == cardinal.opposite || slope == neighbour.slope) && (neighbour.slope == nil || neighbour.slope == cardinal))
    }
    
    override func collapse() {
        
        guard let tilemap = scene?.world.tilemaps.terrain, tilesetTile == nil else { return }
        
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
    
    override func render(position: Vector) -> [Polygon] {
        
        guard let tileUVs = tilesetTile?.uvs.uvs,
              let edges = scene?.world.tilemaps.terrain.edgeset.edges(with: tileType) else { return [] }
        
        var throneVectors = Ordinal.allCases.map { position + $0.vector }
        var apexVectors = throneVectors.map { $0 + Vector(x: 0.0, y: World.Constants.slope * Double(coordinate.y), z: 0.0) }
        
        if let slope = slope {
            
            let (o0, o1) = slope.ordinals
            
            apexVectors[o0.rawValue].y += World.Constants.slope
            apexVectors[o1.rawValue].y += World.Constants.slope
        }
        
        let apexNormal = apexVectors.normal()
        let apexCentre = apexVectors.average()
        
        for cardinal in Cardinal.allCases {
            
            guard find(neighbour: cardinal) == nil else { continue }
            
            let (o0, o1) = cardinal.ordinals
            
            throneVectors[o0.rawValue] += cardinal.normal * World.Constants.slope
            throneVectors[o1.rawValue] += cardinal.normal * World.Constants.slope
        }
        
        var polygons: [Polygon] = []
        
        for cardinal in Cardinal.allCases {
            
            let (o0, o1) = cardinal.ordinals
            
            polygons.append(Polygon(vertices: [Vertex(position: apexVectors[o0.rawValue], normal: apexNormal, color: tileType.color, textureCoordinates: tileUVs[cardinal.rawValue]),
                                               Vertex(position: apexCentre, normal: apexNormal, color: tileType.color, textureCoordinates: tileUVs.average()),
                                               Vertex(position: apexVectors[o1.rawValue], normal: apexNormal, color: tileType.color, textureCoordinates: tileUVs[(cardinal.rawValue + 1) % 4])]))
            
            guard let edgeUVs = edges.randomElement(using: &rng)?.uvs.uvs else { continue }
            
            guard let neighbour = find(neighbour: cardinal) else {
                
                polygons.append(Polygon(vertices: [Vertex(position: apexVectors[o0.rawValue], normal: cardinal.normal, color: tileType.color, textureCoordinates: edgeUVs[0]),
                                                   Vertex(position: apexVectors[o1.rawValue], normal: cardinal.normal, color: tileType.color, textureCoordinates: edgeUVs[1]),
                                                   Vertex(position: (throneVectors[o1.rawValue] - Vector(x: 0, y: Constants.throne, z: 0)), normal: cardinal.normal, color: tileType.color, textureCoordinates: edgeUVs[2]),
                                                   Vertex(position: (throneVectors[o0.rawValue] - Vector(x: 0, y: Constants.throne, z: 0)), normal: cardinal.normal, color: tileType.color, textureCoordinates: edgeUVs[3])]))
                
                continue
            }
            
            let tileCorners = cornerHeights
            let neighbourCorners = neighbour.cornerHeights
            
            let (o2, o3) = cardinal.opposite.ordinals
            
            let (corner0, corner3) = (tileCorners[o0.rawValue], min(tileCorners[o0.rawValue], neighbourCorners[o3.rawValue]))
            let (corner1, corner2) = (tileCorners[o1.rawValue], min(tileCorners[o1.rawValue], neighbourCorners[o2.rawValue]))
            
            if corner0 == corner3 && corner1 == corner2 { continue }
            
            var vertices = [Vertex(position: apexVectors[o0.rawValue], normal: cardinal.normal, color: tileType.color, textureCoordinates: edgeUVs[0]),
                            Vertex(position: apexVectors[o1.rawValue], normal: cardinal.normal, color: tileType.color, textureCoordinates: edgeUVs[1])]
            
            if corner0 == corner3 || corner1 == corner2 {
                
                let (corner, height, uvIndex) = (corner0 == corner3 ? (o1, corner2, 2) : (o0, corner3, 3))
                
                vertices.append(Vertex(position: (throneVectors[corner.rawValue] + Vector(x: 0.0, y: World.Constants.slope * Double(height), z: 0.0)), normal: cardinal.normal, color: tileType.color, textureCoordinates: edgeUVs[uvIndex]))
                
                polygons.append(Polygon(vertices: vertices))
                
                continue
            }
            
            vertices.append(contentsOf: [Vertex(position: (throneVectors[o1.rawValue] + Vector(x: 0, y: World.Constants.slope * Double(neighbourCorners[o3.rawValue]), z: 0)), normal: cardinal.normal, color: tileType.color, textureCoordinates: edgeUVs[2]),
                                         Vertex(position: (throneVectors[o0.rawValue] - Vector(x: 0, y: World.Constants.slope * Double(neighbourCorners[o2.rawValue]), z: 0)), normal: cardinal.normal, color: tileType.color, textureCoordinates: edgeUVs[3])])
            
            polygons.append(Polygon(vertices: vertices))
        }
        
        return polygons
    }
}
