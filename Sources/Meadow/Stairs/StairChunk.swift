//
//  StairChunk.swift
//
//  Created by Zack Brown on 18/05/2021.
//

import Euclid
import SceneKit

public class StairChunk: FootprintChunk {
    
    private enum CodingKeys: String, CodingKey {
        
        case stairType = "t"
        case width = "w"
        case height = "h"
        case elevation = "e"
    }
    
    public override var category: Int { SceneGraphCategory.stairChunk.rawValue }
    
    public override var footprint: Footprint {
        
        let bounds = GridBounds(start: coordinate, end: coordinate + Coordinate(x: width - 1, y: 0, z: height - 1))
        
        return Footprint(bounds: bounds)
    }
    
    var stairType: StairType
    public var width: Int = 0
    public var height: Int = 0
    var elevation: Int = 1
    
    required public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        stairType = try container.decode(StairType.self, forKey: .stairType)
        width = try container.decode(Int.self, forKey: .width)
        height = try container.decode(Int.self, forKey: .height)
        elevation = try container.decode(Int.self, forKey: .elevation)
        
        try super.init(from: decoder)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func encode(to encoder: Encoder) throws {
        
        try super.encode(to: encoder)
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(stairType, forKey: .stairType)
        try container.encode(width, forKey: .width)
        try container.encode(height, forKey: .height)
        try container.encode(elevation, forKey: .elevation)
    }
    
    public override func clean() -> Bool {
        
        guard super.clean() else { return false }
        
        var size: Coordinate
        
        switch direction {
        
        case .north,
             .south:
            
            size = Coordinate(x: footprint.bounds.size.x, y: elevation, z: footprint.bounds.size.z)
            
        case .east,
             .west:
            
            size = Coordinate(x: footprint.bounds.size.z, y: elevation, z: footprint.bounds.size.x)
        }
        
        let steps = 2 * elevation
        let scalar = 1.0 / Double(steps)
        
        let upperFace = TileVolume.face(position: .zero, size: size, elevation: coordinate.y + elevation)
        let lowerFace = TileVolume.face(position: .zero, size: size, elevation: coordinate.y)
        
        var polygons: [Euclid.Polygon] = []
        
        for step in 0..<steps {
            
            var apex: [Vector] = []
            var throne: [Vector] = []
            
            let i = Double(step)
            let j = Double(step + 1)
            
            for cardinal in Cardinal.allCases {
                
                apex.append(lowerFace[cardinal.rawValue].lerp(upperFace[cardinal.rawValue], j * scalar))
                throne.append(lowerFace[cardinal.rawValue].lerp(upperFace[cardinal.rawValue], i * scalar))
            }
            
            let uv0 = apex[Ordinal.northWest.rawValue]
            let uv1 = apex[Ordinal.northEast.rawValue]
            let uv2 = apex[Ordinal.southEast.rawValue]
            let uv3 = apex[Ordinal.southWest.rawValue]
            
            let lv0 = throne[Ordinal.northWest.rawValue]
            let lv1 = throne[Ordinal.northEast.rawValue]
            let lv2 = throne[Ordinal.southEast.rawValue]
            let lv3 = throne[Ordinal.southWest.rawValue]
            
            let uc0 = uv3.lerp(uv0, j * scalar)
            let uc1 = uv2.lerp(uv1, j * scalar)
            let uc2 = uv2.lerp(uv1, i * scalar)
            let uc3 = uv3.lerp(uv0, i * scalar)
            
            let lc0 = lv3.lerp(lv0, i * scalar)
            let lc1 = lv2.lerp(lv1, i * scalar)
            
            let faces = [[uc0, uc1, uc2, uc3],
                         [uc3, uc2, lc1, lc0]]
            
            for face in faces {
                
                let normal = -face.normal()
                
                var vertices: [Vertex] = []
                
                for index in face.indices.reversed() {
                    
                    vertices.append(Vertex(face[index], normal))
                }
                
                guard let polygon = Polygon(vertices) else { continue }
                
                polygons.append(polygon)
            }
        }
        
        let radians = Angle(radians: Math.radians(degrees: 90.0 * Double(direction.rawValue)))
        
        let yaw = Rotation(yaw: radians)

        let offset = Vector(x: (Double(footprint.bounds.size.x) / 2.0) - World.Constants.volumeSize, y: 0, z: (Double(footprint.bounds.size.z) / 2.0) - World.Constants.volumeSize)
        
        let transform = Transform(offset: offset, rotation: yaw)
        
        self.geometry = SCNGeometry(Mesh(polygons).transformed(by: transform))
        
        return true
    }
}

extension StairChunk: Traversable {
    
    var movementCost: Double { 1 }
    var walkable: Bool { true }
    
    func traversableNode(for coordinate: Coordinate) -> TraversableNode {
        
        var cardinals = [direction, direction.opposite]
        
        let (c0, c1) = direction.cardinals
        
        for cardinal in [c0, c1] {
            
            if footprint.intersects(coordinate: coordinate + cardinal.coordinate) {
                
                cardinals.append(cardinal)
            }
        }
        
        return TraversableNode(coordinate: Coordinate(x: coordinate.x, y: self.coordinate.y + elevation, z: coordinate.z), vector: coordinate.world, movementCost: movementCost, sloped: true, cardinals: cardinals)
    }
}
