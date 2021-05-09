//
//  BridgeChunk.swift
//
//  Created by Zack Brown on 08/05/2021.
//

import SceneKit

public class BridgeChunk: FootprintChunk {
    
    private enum CodingKeys: String, CodingKey {
        
        case footprint = "f"
    }
    
    let footprint: Footprint
    
    required public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        footprint = try container.decode(Footprint.self, forKey: .footprint)
        
        try super.init(from: decoder)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func encode(to encoder: Encoder) throws {
        
        try super.encode(to: encoder)
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(footprint, forKey: .footprint)
    }
    
    public override func clean() -> Bool {
        
        guard isDirty else { return false }
        
        position = SCNVector3(vector: coordinate.world)
        
        var polygons: [Polygon] = []
        
        for node in footprint.nodes {
        
            let corners = Ordinal.allCases.map { $0.vector + (footprint.coordinate - node).world }
            
            let normal = corners.normal()
            
            var vertices: [Vertex] = []
            
            for index in 0..<corners.count {
                
                vertices.append(Vertex(position: corners[index], normal: normal, color: Color(red: 1, green: 0.5, blue: 0.5)))
            }
            
            polygons.append(Polygon(vertices: vertices))
        }
        
        self.geometry = SCNGeometry(mesh: Mesh(polygons: polygons))
        
        isDirty = true
        
        return true
    }
}
