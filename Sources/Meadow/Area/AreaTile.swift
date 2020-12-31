//
//  AreaTile.swift
//
//  Created by Zack Brown on 08/12/2020.
//

import Foundation

public class AreaTile: Tile {
    
    public override var category: Int { SceneGraphCategory.areaTile.rawValue }
    override var movementCost: Int { tileType.movementCost }
    
    public var tileType: AreaTileType = .sand {
        
        didSet {
            
            guard oldValue != tileType else { return }
            
            tilesetTile = nil
            
            becomeDirty()
        }
    }
    
    var tilesetTile: AreaTilesetTile? {
        
        didSet {
            
            guard oldValue != tilesetTile else { return }
            
            becomeDirty()
        }
    }
    
    override func invalidate(neighbours: Bool) {
        
        tilesetTile = nil
        
        becomeDirty()
        
        guard neighbours else { return }
        
        for cardinal in Cardinal.allCases {
            
            guard let neighbour = find(neighbour: cardinal) else { continue }
            
            neighbour.invalidate(neighbours: false)
        }
        
        for ordinal in Ordinal.allCases {
            
            guard let neighbour = find(neighbour: ordinal) else { continue }
            
            neighbour.invalidate(neighbours: false)
        }
    }
    
    override func update(delta: TimeInterval, time: TimeInterval) {
        
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
        
        guard let tilemap = scene?.world.tilemaps.area, tilesetTile == nil else { return }
        
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
            
            var t0: AreaTileType? = d0?.tileType == tileType.next ? tileType.next : nil
            var t1: AreaTileType? = d1?.tileType == tileType.next ? tileType.next : nil
            
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
        
        guard let edges = scene?.world.tilemaps.area.edgeset.edges(with: tileType) else { return polygons }
        
        var rng = RNG(seed: UInt64(seed))
        
        //
        //  Create tile edges
        //
        for cardinal in Cardinal.allCases {
            
            guard let edge = edges.randomElement(using: &rng) else { continue }
            
            let (o0, o1) = cardinal.ordinals
            
            guard let neighbour = find(neighbour: cardinal) else {
                
                polygons.append(Polygon(vertices: [Vertex(position: apexVectors[o0.rawValue], normal: -cardinal.normal, color: tileType.color, textureCoordinates: edge.uvs.uvs[0]),
                                                   Vertex(position: apexVectors[o1.rawValue], normal: -cardinal.normal, color: tileType.color, textureCoordinates: edge.uvs.uvs[1]),
                                                   Vertex(position: (corners[o1.rawValue] + Vector(x: 0, y: World.Constants.wall, z: 0)), normal: -cardinal.normal, color: tileType.color, textureCoordinates: edge.uvs.uvs[2]),
                                                   Vertex(position: (corners[o0.rawValue] + Vector(x: 0, y: World.Constants.wall, z: 0)), normal: -cardinal.normal, color: tileType.color, textureCoordinates: edge.uvs.uvs[3])]))
                
                continue
            }
            
            let tileCorners = cornerHeights
            let neighbourCorners = neighbour.cornerHeights
            
            let (o2, o3) = cardinal.opposite.ordinals
            
            let (c0, c3) = (tileCorners[o0.rawValue], min(tileCorners[o0.rawValue], neighbourCorners[o3.rawValue]))
            let (c1, c2) = (tileCorners[o1.rawValue], min(tileCorners[o1.rawValue], neighbourCorners[o2.rawValue]))
            
            if c0 == c3 && c1 == c2 { continue }
            
            var vertices = [Vertex(position: apexVectors[o0.rawValue], normal: cardinal.normal, color: tileType.color, textureCoordinates: edge.uvs.uvs[0]),
                            Vertex(position: apexVectors[o1.rawValue], normal: cardinal.normal, color: tileType.color, textureCoordinates: edge.uvs.uvs[1])]
            
            if c0 == c3 || c1 == c2 {
                
                let (corner, height, uvIndex) = (c0 == c3 ? (o1, c2, 2) : (o0, c3, 3))
                
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
