//
//  BridgeChunk.swift
//
//  Created by Zack Brown on 08/05/2021.
//

import SceneKit

public class BridgeChunk: FootprintChunk {
    
    private enum CodingKeys: String, CodingKey {
        
        case footprint = "f"
        case direction = "d"
    }
    
    public override var category: Int { SceneGraphCategory.bridgeChunk.rawValue }
    
    let footprint: Footprint
    let direction: Cardinal
    
    required public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        footprint = try container.decode(Footprint.self, forKey: .footprint)
        direction = try container.decode(Cardinal.self, forKey: .direction)
        
        try super.init(from: decoder)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func encode(to encoder: Encoder) throws {
        
        try super.encode(to: encoder)
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(footprint, forKey: .footprint)
        try container.encode(direction, forKey: .direction)
    }
    
    public override func clean() -> Bool {
        
        guard super.clean() else { return false }
        
        var polygons: [Polygon] = []
        
        for node in footprint.nodes {
            
            let offset = (node.xz - footprint.bounds.start.xz).world + Vector(x: 0, y: 0.001, z: 0)
            
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
    
    func pathNode(for coordinate: Coordinate) -> PathNode {
        
        var cardinals = [direction, direction.opposite]
        
        let (c0, c1) = direction.cardinals
        
        for cardinal in [c0, c1] {
            
            if footprint.intersects(coordinate: coordinate + cardinal.coordinate) {
                
                cardinals.append(cardinal)
            }
        }
        
        return PathNode(coordinate: coordinate, vector: coordinate.world, movementCost: movementCost, sloped: false, cardinals: cardinals)
    }
}
