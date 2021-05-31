//
//  SurfaceTile.swift
//
//  Created by Zack Brown on 23/12/2020.
//

import SceneKit

public class SurfaceTile: Tile {
    
    private enum CodingKeys: String, CodingKey {
        
        case tileType = "tt"
        case edgeType = "et"
        case edgePatterns = "ep"
        case volumes = "v"
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
    let volumes: [Ordinal : TileVolume]
    
    var color: Color {
        
        return Color(red: Double(tileType.primary.rawValue), green: Double(tileType.secondary.rawValue), blue: 0, alpha: 1)
    }

    required public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        tileType = try container.decode(TileType.self, forKey: .tileType)
        edgeType = try container.decode(SurfaceEdgeType.self, forKey: .edgeType)
        edgePatterns = try container.decode([Cardinal : Int].self, forKey: .edgePatterns)
        volumes = try container.decode([Ordinal : TileVolume].self, forKey: .volumes)
        
        try super.init(from: decoder)
    }
    
    public override func encode(to encoder: Encoder) throws {
        
        try super.encode(to: encoder)
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(tileType, forKey: .tileType)
        try container.encode(edgeType, forKey: .edgeType)
        try container.encode(edgePatterns, forKey: .edgePatterns)
        try container.encode(volumes, forKey: .volumes)
    }
    
    override func render(position: Vector) -> [Polygon] {
        
        let tile = scene?.meadow.surface.tilemap.tileset.tiles(with: apexPattern).randomElement()
        
        var polygons: [Polygon] = []
        
        for ordinal in Ordinal.allCases {
            
            guard let volume = volumes[ordinal] else { continue }
            
            let size = World.Constants.volumeSize / 2.0
            
            let offset = ordinal.coordinate.world * size
            
            let upperFace = TileVolume.face(position: position + offset, size: size, elevation: World.Constants.ceiling)
            let lowerFace = TileVolume.face(position: position + offset, size: size, elevation: 0)
            
            var apex: [Vector] = []
            
            for index in volume.apex.corners.indices {
                
                apex.append(lowerFace[index].lerp(vector: upperFace[index], interpolater: volume.apex.corners[index]))
            }
            
            let normal = -apex.normal()
            let apexUVs = (tile?.uvs ?? UVs(start: .zero, end: .one)).slice(ordinal: ordinal)
            
            var vertices: [Vertex] = []
            
            for index in apex.indices.reversed() {
                
                vertices.append(Vertex(position: apex[index], normal: normal, color: color, textureCoordinates: apexUVs[index]))
            }
            
            polygons.append(Polygon(vertices: vertices))
            
            guard !volume.edges.isEmpty else { continue }
            
            for (cardinal, edges) in volume.edges {
                
                guard let edgePattern = edgePatterns[cardinal] else { continue }
                
                let (o0, o1) = cardinal.ordinals
                
                let edge = scene?.meadow.surface.tilemap.edgeset.edges(with: edgePattern).randomElement()
                
                let edgeUVs = (edge?.uvs ?? UVs(start: .zero, end: .one)).slice(cardinal: ((ordinal.rawValue == cardinal.rawValue || ordinal.rawValue == ((cardinal.rawValue + 4) - 1) % 4) ? .west : .east))
                
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
                    
                    vertices.append(Vertex(position: face[index], normal: normal, color: color, textureCoordinates: edgeUVs[index]))
                }
                
                polygons.append(Polygon(vertices: vertices))
            }
        }
        
        return polygons
    }
}

extension SurfaceTile {
    
    public static func == (lhs: SurfaceTile, rhs: SurfaceTile) -> Bool {
        
        return lhs.coordinate == rhs.coordinate && lhs.apexPattern == rhs.apexPattern && lhs.tileType == rhs.tileType
    }
}

extension SurfaceTile: Traversable {
    
    var movementCost: Double { tileType.primary.movementCost }
    var walkable: Bool {
        
        switch edgeType {
        
        case .cutaway:
            
            return true
        
        case .sloped:
            
            let apex = volumes.apex()
            
            guard let min = apex.min(),
                  let max = apex.max() else { return false }
            
            return max - min <= World.Constants.step
            
        case .terraced:
            
            let apex = volumes.apex()
            
            guard let min = apex.min(),
                  let max = apex.max() else { return false }
            
            return max == min
        }
    }
    
    func pathNode(for coordinate: Coordinate) -> PathNode {
        
        return PathNode(coordinate: self.coordinate, vector: coordinate.world, movementCost: movementCost, sloped: edgeType == .sloped, cardinals: Cardinal.allCases)
    }
}
