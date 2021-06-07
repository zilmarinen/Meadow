//
//  BridgeChunk.swift
//
//  Created by Zack Brown on 08/05/2021.
//

import SceneKit

public class BridgeChunk: FootprintChunk {
    
    private enum CodingKeys: String, CodingKey {
        
        case width = "w"
        case height = "h"
    }
    
    public override var category: Int { SceneGraphCategory.bridgeChunk.rawValue }
    
    public override var footprint: Footprint {
        
        let bounds = GridBounds(start: coordinate, end: coordinate + Coordinate(x: width - 1, y: 0, z: height - 1))
        
        return Footprint(bounds: bounds)
    }
    
    public var width: Int = 0
    public var height: Int = 0
    
    required public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        width = try container.decode(Int.self, forKey: .width)
        height = try container.decode(Int.self, forKey: .height)
        
        try super.init(from: decoder)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func encode(to encoder: Encoder) throws {
        
        try super.encode(to: encoder)
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(width, forKey: .width)
        try container.encode(height, forKey: .height)
    }
    
    public override func clean() -> Bool {
        
        guard super.clean() else { return false }
        
        var polygons: [Polygon] = []
        
        for node in footprint.nodes {
            
            let offset = (node.xz - coordinate.xz).world + Vector(x: 0, y: 0.001, z: 0)
            
            let upperFace = TileVolume.face(position: offset, size: World.Constants.volumeSize, elevation: World.Constants.ceiling)
            let lowerFace = TileVolume.face(position: offset, size: World.Constants.volumeSize, elevation: 0)
            
            let elevation = Double(coordinate.y) * World.Constants.yScalar
            
            var apex: [Vector] = []
            
            for cardinal in Cardinal.allCases {
                
                apex.append(lowerFace[cardinal.rawValue].lerp(vector: upperFace[cardinal.rawValue], interpolater: elevation))
            }
            
            let normal = -apex.normal()
            
            var vertices: [Vertex] = []
            
            for index in apex.indices.reversed() {
                
                vertices.append(Vertex(position: apex[index], normal: normal, color: Color(red: 0.14, green: 0.14, blue: 0.14)))
            }
            
            polygons.append(Polygon(vertices: vertices))
        }
        
        self.geometry = SCNGeometry(mesh: Mesh(polygons: polygons))
        
        return true
    }
}

extension BridgeChunk: Traversable {
    
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
        
        return TraversableNode(coordinate: coordinate, vector: coordinate.world, movementCost: movementCost, sloped: false, cardinals: cardinals)
    }
}
