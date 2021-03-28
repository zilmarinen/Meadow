//
//  WaterTile.swift
//
//  Created by Zack Brown on 26/03/2021.
//

import SceneKit

public class WaterTile: Tile {
    
    enum Constants {
        
        static let surface = World.Constants.slope / 2
    }
    
    private enum CodingKeys: CodingKey {
        
        case tileType
    }
    
    public override var category: Int { SceneGraphCategory.surfaceTile.rawValue }

    let tileType: WaterTileType
    
    var color: Color {
        
        return Color(red: Double(tileType.rawValue), green: 0, blue: 0, alpha: 1)
    }

    required public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        tileType = try container.decode(WaterTileType.self, forKey: .tileType)
        
        try super.init(from: decoder)
    }
    
    public override func encode(to encoder: Encoder) throws {
        
        try super.encode(to: encoder)
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(tileType, forKey: .tileType)
    }
    
    override func render(position: Vector) -> [Polygon] {
        
        guard let surfaceTile = scene?.meadow.surface.find(tile: coordinate) else { return [] }
        
        let face = Ordinal.allCases.map { $0.vector + position + Vector(x: 0, y: (Double(coordinate.y) * World.Constants.slope) - Constants.surface, z: 0) }
        
        let normal = face.normal()
        
        let faceColor = color
        
        var vertices: [Vertex] = []
        
        for index in 0..<face.count {
            
            vertices.append(Vertex(position: face[index], normal: normal, color: faceColor))
        }
        
        return [Polygon(vertices: vertices)]
    }
}

extension WaterTile {
    
    public static func == (lhs: WaterTile, rhs: WaterTile) -> Bool {
        
        return lhs.coordinate == rhs.coordinate && lhs.pattern == rhs.pattern && lhs.tileType == rhs.tileType
    }
}
