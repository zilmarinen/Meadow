//
//  Model.swift
//
//  Created by Zack Brown on 08/04/2021.
//

public struct Model: Codable {
    
    private enum CodingKeys: String, CodingKey {
        
        case footprint = "f"
        case polygons = "p"
    }
    
    public let footprint: Footprint
    public let mesh: Mesh
    
    init(footprint: Footprint, polygons: [Polygon]) {
        
        self.footprint = footprint
        self.mesh = Mesh(polygons: polygons)
    }
    
    public init(from decoder: Decoder) throws {
           
        let container = try decoder.container(keyedBy: CodingKeys.self)
       
        let polygons = try container.decode([Polygon].self, forKey: .polygons)
        
        footprint = try container.decode(Footprint.self, forKey: .footprint)
        mesh = Mesh(polygons: polygons)
    }
   
    public func encode(to encoder: Encoder) throws {
       
        var container = encoder.container(keyedBy: CodingKeys.self)
       
        try container.encode(footprint, forKey: .footprint)
        try container.encode(mesh.polygons, forKey: .polygons)
    }
}
