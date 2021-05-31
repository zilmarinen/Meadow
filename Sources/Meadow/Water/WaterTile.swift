//
//  WaterTile.swift
//
//  Created by Zack Brown on 26/03/2021.
//

import SceneKit

public class WaterTile: Tile {
    
    private enum CodingKeys: String, CodingKey {
        
        case tileType = "t"
        case volume = "v"
    }
    
    public override var category: Int { SceneGraphCategory.surfaceTile.rawValue }

    let tileType: WaterTileType
    let volume: TileVolume
    
    var color: Color {
        
        return Color(red: Double(tileType.rawValue), green: 0, blue: 0, alpha: 1)
    }

    required public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        tileType = try container.decode(WaterTileType.self, forKey: .tileType)
        volume = try container.decode(TileVolume.self, forKey: .volume)
        
        try super.init(from: decoder)
    }
    
    public override func encode(to encoder: Encoder) throws {
        
        try super.encode(to: encoder)
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(tileType, forKey: .tileType)
        try container.encode(volume, forKey: .volume)
    }
    
    override func render(position: Vector) -> [Polygon] {
        
        var polygons: [Polygon] = []
        
        let upperFace = TileVolume.face(position: position, size: World.Constants.volumeSize, elevation: World.Constants.ceiling)
        let lowerFace = TileVolume.face(position: position, size: World.Constants.volumeSize, elevation: 0)
        
        var apex: [Vector] = []
        
        for index in volume.apex.corners.indices {
            
            apex.append(lowerFace[index].lerp(vector: upperFace[index], interpolater: volume.apex.corners[index]))
        }
        
        let normal = -apex.normal()
        
        var vertices: [Vertex] = []
        
        for index in apex.indices.reversed() {
            
            vertices.append(Vertex(position: apex[index], normal: normal, color: color))
        }
        
        polygons.append(Polygon(vertices: vertices))
        
        guard !volume.edges.isEmpty else { return polygons }
        
        for (cardinal, edges) in volume.edges {
            
            let (o0, o1) = cardinal.ordinals
            
            var face: [Vector] = [apex[o0.rawValue], apex[o1.rawValue]]
            
            if let height = edges[o1] {
                
                face.append(lowerFace[o1.rawValue].lerp(vector: upperFace[o1.rawValue], interpolater: height))
            }
            
            if let height = edges[o0] {
                
                face.append(lowerFace[o0.rawValue].lerp(vector: upperFace[o0.rawValue], interpolater: height))
            }
            
            let normal = cardinal.normal
            
            var vertices: [Vertex] = []
            
            for index in face.indices {
                
                vertices.append(Vertex(position: face[index], normal: normal, color: color))
            }
            
            polygons.append(Polygon(vertices: vertices))
        }
        
        return polygons
    }
}

extension WaterTile {
    
    public static func == (lhs: WaterTile, rhs: WaterTile) -> Bool {
        
        return lhs.coordinate == rhs.coordinate && lhs.apexPattern == rhs.apexPattern && lhs.tileType == rhs.tileType
    }
}
