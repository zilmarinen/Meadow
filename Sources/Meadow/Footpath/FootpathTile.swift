//
//  FootpathTile.swift
//
//  Created by Zack Brown on 25/03/2021.
//

import Euclid
import SceneKit

public class FootpathTile: Tile {
    
    private enum CodingKeys: String, CodingKey {
        
        case tileType = "t"
        case pattern = "p"
    }
    
    public override var category: SceneGraphCategory { .surfaceTile }

    let tileType: FootpathTileType
    let pattern: Int
    
    var color: Color {
        
        return Color(red: Double(tileType.rawValue), green: 0, blue: 0, alpha: 1)
    }

    required public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        tileType = try container.decode(FootpathTileType.self, forKey: .tileType)
        pattern = try container.decode(Int.self, forKey: .pattern)
        
        try super.init(from: decoder)
    }
    
    public override func encode(to encoder: Encoder) throws {
        
        try super.encode(to: encoder)
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(tileType, forKey: .tileType)
        try container.encode(pattern, forKey: .pattern)
    }
    
    override func render(position: Vector) -> [Euclid.Polygon] {
        
        guard let surfaceTile = map?.surface.find(tile: coordinate) else { return [] }
        
        let size = World.Constants.volumeSize / 2.0
        
        let upperFace = TileVolume.face(position: position, size: size, elevation: World.Constants.ceiling)
        let lowerFace = TileVolume.face(position: position, size: size, elevation: 0)
        
        var face: [Vector] = []
        
        for ordinal in Ordinal.allCases.reversed() {
            
            guard let interpolator = surfaceTile.volumes[ordinal]?.apex.corners[ordinal.rawValue] else { return [] }
            
            var corner = position + (Vector(coordinate: ordinal.coordinate) * World.Constants.volumeSize)
            
            corner.y = lowerFace[ordinal.rawValue].lerp(upperFace[ordinal.rawValue], interpolator).y + 0.001
            
            face.append(corner)
        }
        
        let tile = map?.footpath.tilemap.tileset.tiles(with: pattern, tileType: tileType).randomElement()
        
        let tileUVs = tile?.uvs ?? UVs(start: .zero, end: .one)
                    
        let normal = face.normal()
                
        let faceColor = color
                
        var vertices: [Vertex] = []
                
        for index in face.indices {

            vertices.append(Vertex(face[index], normal, tileUVs[index]))
        }
                
        guard let polygon = Polygon(vertices) else { return [] }
        
        return [polygon]
    }
}

extension FootpathTile {
    
    public static func == (lhs: FootpathTile, rhs: FootpathTile) -> Bool {
        
        return lhs.coordinate == rhs.coordinate && lhs.pattern == rhs.pattern && lhs.tileType == rhs.tileType
    }
}
