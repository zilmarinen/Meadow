//
//  SurfaceTile.swift
//
//  Created by Zack Brown on 23/12/2020.
//

import SceneKit

public class SurfaceTile: Tile {
    
    private enum CodingKeys: CodingKey {
        
        case tileType
        case edgeType
        case edgePatterns
        case corners
    }
    
    public struct TileType: Codable, Equatable {
        
        public var primary: SurfaceTileType = .dirt
        public var secondary: SurfaceTileType = .dirt
        
        public init(primary: SurfaceTileType = .dirt, secondary: SurfaceTileType = .dirt) {
            
            self.primary = primary
            self.secondary = secondary
        }
    }
    
    public override var category: Int { SceneGraphCategory.surfaceTile.rawValue }

    let tileType: TileType
    let edgeType: SurfaceEdgeType
    let edgePatterns: [Cardinal : Int]
    let corners: [Ordinal : Int]
    
    var color: Color {
        
        return Color(red: Double(tileType.primary.rawValue), green: Double(tileType.secondary.rawValue), blue: 0, alpha: 1)
    }

    required public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        tileType = try container.decode(TileType.self, forKey: .tileType)
        edgeType = try container.decode(SurfaceEdgeType.self, forKey: .edgeType)
        edgePatterns = try container.decode([Cardinal : Int].self, forKey: .edgePatterns)
        corners = try container.decode([Ordinal : Int].self, forKey: .corners)
        
        try super.init(from: decoder)
    }
    
    public override func encode(to encoder: Encoder) throws {
        
        try super.encode(to: encoder)
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(tileType, forKey: .tileType)
        try container.encode(edgeType, forKey: .edgeType)
        try container.encode(edgePatterns, forKey: .edgePatterns)
        try container.encode(corners, forKey: .corners)
    }
    
    override func render(position: Vector) -> [Polygon] {
        
        let face = Ordinal.allCases.map { $0.vector + position + Vector(x: 0, y: Double(corners[$0] ?? 0) * World.Constants.slope, z: 0) }
        var throne = face
        
        for ordinal in Ordinal.allCases {
            
            throne[ordinal.rawValue].y = Double(World.Constants.floor - 1) * World.Constants.slope
        }
        
        let equalEdges = corners.filter { $0.value == coordinate.y }.count
        
        let tile = scene?.meadow.surface.tilemap.tileset.tiles(with: pattern).randomElement()
        
        let tileUVs = tile?.uvs ?? UVs(start: .zero, end: .one)
        
        let faceColor = color
        
        if (equalEdges == 4 || (equalEdges == 2 && edgeType == .sloped)) {
            
            let normal = face.normal()
            
            var vertices: [Vertex] = []
            
            for index in 0..<face.count {
                
                vertices.append(Vertex(position: face[index], normal: normal, color: faceColor, textureCoordinates: tileUVs[index]))
            }
            
            return [Polygon(vertices: vertices)]
        }
        
        var polygons: [Polygon] = []
        
        switch edgeType {
        
        case .sloped:
            
            for ordinal in Ordinal.allCases {
                
                let j = (ordinal.rawValue + 1) % 4
                let k = (ordinal.rawValue - 1 + 4) % 4
                
                guard let o0 = Ordinal(rawValue: j),
                      let o1 = Ordinal(rawValue: k) else { continue }
                
                guard corners[o0] == corners[o1] else { continue }
                
                let v0 = face[ordinal.rawValue]
                let v1 = face[j]
                let v2 = face[k]
                
                let normal = [v0, v1, v2].normal()
                
                polygons.append(Polygon(vertices: [Vertex(position: v0, normal: normal, color: faceColor, textureCoordinates: tileUVs[ordinal.rawValue]),
                                                   Vertex(position: v1, normal: normal, color: faceColor, textureCoordinates: tileUVs[j]),
                                                   Vertex(position: v2, normal: normal, color: faceColor, textureCoordinates: tileUVs[k])]))
            }
            
        case .terraced:
            
            var mantle = face
            var apex = face
            
            let floor = corners.values.min() ?? coordinate.y
            
            for ordinal in Ordinal.allCases {
                
                mantle[ordinal.rawValue].y = Double(floor) * World.Constants.slope
                apex[ordinal.rawValue].y = Double(coordinate.y) * World.Constants.slope
            }
            
            let mantleCenter = mantle.average()
            let apexCenter = apex.average()
            
            for ordinal in Ordinal.allCases {
                
                let j = (ordinal.rawValue + 1) % 4
                let k = (ordinal.rawValue - 1 + 4) % 4
                
                guard let o0 = Ordinal(rawValue: j),
                      let o1 = Ordinal(rawValue: k),
                      let height = corners[ordinal] else { continue }
                
                let (c0, c1) = ordinal.cardinals
                
                let face = (height == coordinate.y ? apex : mantle)
                let center = (height == coordinate.y ? apexCenter : mantleCenter)
                
                let v0 = face[ordinal.rawValue]
                let v1 = v0.lerp(vector: face[o0.rawValue], interpolater: 0.5)
                let v2 = v0.lerp(vector: face[o1.rawValue], interpolater: 0.5)
                
                let uv0 = tileUVs[ordinal.rawValue]
                let uv1 = uv0.lerp(point: tileUVs[o0.rawValue], interpolater: 0.5)
                let uv2 = uv0.lerp(point: tileUVs[o1.rawValue], interpolater: 0.5)
                let uv3 = tileUVs.uvs.average()
                
                var normal = [v0, v1, center, v2].normal()
                
                polygons.append(Polygon(vertices: [Vertex(position: v0, normal: normal, color: faceColor, textureCoordinates: uv0),
                                                   Vertex(position: v1, normal: normal, color: faceColor, textureCoordinates: uv1),
                                                   Vertex(position: center, normal: normal, color: faceColor, textureCoordinates: uv3),
                                                   Vertex(position: v2, normal: normal, color: faceColor, textureCoordinates: uv2)]))
                
                if let corner = corners[o0],
                   height > corner,
                   let edgePattern = edgePatterns[c0] {

                    let edge = scene?.meadow.surface.tilemap.edgeset.edges(with: edgePattern).randomElement()

                    let edgeUVs = edge?.uvs ?? UVs(start: .zero, end: .one)

                    let v3 = mantle[ordinal.rawValue].lerp(vector: mantle[o0.rawValue], interpolater: 0.5)

                    normal = [apexCenter, v1, v3, mantleCenter].normal()
                    
                    let uv0 = edgeUVs.start.lerp(point: CGPoint(x: edgeUVs.end.x, y: edgeUVs.start.y), interpolater: 0.5)

                    polygons.append(Polygon(vertices: [Vertex(position: apexCenter, normal: normal, color: color, textureCoordinates: CGPoint(x: uv0.x, y: edgeUVs.end.y)),
                                                       Vertex(position: v1, normal: normal, color: color, textureCoordinates: CGPoint(x: edgeUVs.start.x, y: edgeUVs.end.y)),
                                                       Vertex(position: v3, normal: normal, color: color, textureCoordinates: edgeUVs.start),
                                                       Vertex(position: mantleCenter, normal: normal, color: color, textureCoordinates: uv0)]))
                }
                
                if let corner = corners[o1],
                   height > corner,
                   let edgePattern = edgePatterns[c1] {

                    let edge = scene?.meadow.surface.tilemap.edgeset.edges(with: edgePattern).randomElement()

                    let edgeUVs = edge?.uvs ?? UVs(start: .zero, end: .one)

                    let v3 = mantle[ordinal.rawValue].lerp(vector: mantle[o1.rawValue], interpolater: 0.5)

                    normal = [v2, apexCenter, mantleCenter, v3].normal()
                    
                    let uv0 = edgeUVs.start.lerp(point: CGPoint(x: edgeUVs.end.x, y: edgeUVs.start.y), interpolater: 0.5)

                    polygons.append(Polygon(vertices: [Vertex(position: v2, normal: normal, color: color, textureCoordinates: edgeUVs.end),
                                                       Vertex(position: apexCenter, normal: normal, color: color, textureCoordinates: CGPoint(x: uv0.x, y: edgeUVs.end.y)),
                                                       Vertex(position: mantleCenter, normal: normal, color: color, textureCoordinates: uv0),
                                                       Vertex(position: v3, normal: normal, color: color, textureCoordinates: CGPoint(x: edgeUVs.end.x, y: edgeUVs.start.y))]))
                }
            }
        }
        
        return polygons
    }
}

extension SurfaceTile {
    
    public static func == (lhs: SurfaceTile, rhs: SurfaceTile) -> Bool {
        
        return lhs.coordinate == rhs.coordinate && lhs.pattern == rhs.pattern && lhs.tileType == rhs.tileType
    }
}
