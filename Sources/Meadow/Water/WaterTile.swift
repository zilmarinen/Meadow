//
//  WaterTile.swift
//
//  Created by Zack Brown on 26/03/2021.
//

import Euclid
import SceneKit

public class WaterTile: Tile {
    
    private enum CodingKeys: String, CodingKey {
        
        case tileType = "t"
        case apexPattern = "ap"
        case volume = "v"
    }
    
    public override var category: SceneGraphCategory { .surfaceTile }

    let tileType: WaterTileType
    let apexPattern: Int
    let volume: TileVolume
    
    var color: Color {
        
        return Color(red: Double(tileType.rawValue), green: 0, blue: 0, alpha: 1)
    }

    required public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        tileType = try container.decode(WaterTileType.self, forKey: .tileType)
        apexPattern = try container.decode(Int.self, forKey: .apexPattern)
        volume = try container.decode(TileVolume.self, forKey: .volume)
        
        try super.init(from: decoder)
    }
    
    public override func encode(to encoder: Encoder) throws {
        
        try super.encode(to: encoder)
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(tileType, forKey: .tileType)
        try container.encode(apexPattern, forKey: .apexPattern)
        try container.encode(volume, forKey: .volume)
    }
    
    override func render(position: Vector) -> [Euclid.Polygon] {
        
        var polygons: [Euclid.Polygon] = []
        
        let upperFace = TileVolume.face(position: position, size: World.Constants.volumeSize, elevation: World.Constants.ceiling)
        let lowerFace = TileVolume.face(position: position, size: World.Constants.volumeSize, elevation: 0)
        
        var apex: [Vector] = []
        
        for index in volume.apex.corners.indices {
            
            apex.append(lowerFace[index].lerp(upperFace[index], volume.apex.corners[index]))
        }
        
        let normal = -apex.normal()
        
        var vertices: [Vertex] = []
        
        for index in apex.indices.reversed() {
            
            vertices.append(Vertex(apex[index], normal))
        }
        
        guard let polygon = Polygon(vertices) else { return [] }
        
        polygons.append(polygon)
        
        guard !volume.edges.isEmpty else { return polygons }
        
        for (cardinal, edges) in volume.edges {
            
            let (o0, o1) = cardinal.ordinals
            
            var face: [Vector] = [apex[o0.rawValue], apex[o1.rawValue]]
            
            if let height = edges[o1] {
                
                face.append(lowerFace[o1.rawValue].lerp(upperFace[o1.rawValue], height))
            }
            
            if let height = edges[o0] {
                
                face.append(lowerFace[o0.rawValue].lerp(upperFace[o0.rawValue], height))
            }
            
            let normal = cardinal.normal
            
            var vertices: [Vertex] = []
            
            for index in face.indices {
                
                vertices.append(Vertex(face[index], normal))
            }
            
            guard let polygon = Polygon(vertices) else { continue }
            
            polygons.append(polygon)
        }
        
        return polygons
    }
}

extension WaterTile {
    
    public static func == (lhs: WaterTile, rhs: WaterTile) -> Bool {
        
        return lhs.coordinate == rhs.coordinate && lhs.apexPattern == rhs.apexPattern && lhs.tileType == rhs.tileType
    }
}
