//
//  Prop.swift
//
//  Created by Zack Brown on 07/12/2020.
//

import SceneKit

public class Prop: SCNNode, Codable, Hideable, Interactive, Responder, SceneGraphNode, Soilable, Updatable {
    
    private enum CodingKeys: CodingKey {
        
        case footprint
    }
    
    public var ancestor: SoilableParent? { parent as? SoilableParent }
    
    public var isDirty: Bool = false
    
    public var children: [SceneGraphNode] { [] }
    public var childCount: Int { children.count }
    public var isLeaf: Bool { children.isEmpty }
    public var category: Int { SceneGraphCategory.prop.rawValue }
    
    public let footprint: Footprint
    
    var pointsOfAccess: [GridNode] { footprint.pointsOfAccess }
    var slots: [InteractionSlot] = []
    
    init(footprint: Footprint) {
        
        self.footprint = footprint
        
        super.init()
        
        name = "Prop \(footprint.coordinate.description)"
        position = SCNVector3(coordinate: footprint.coordinate)
        categoryBitMask = category
    }
    
    required public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        footprint = try container.decode(Footprint.self, forKey: .footprint)
        
        super.init()
        
        categoryBitMask = category
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(footprint, forKey: .footprint)
    }
}

extension Prop {
    
    @discardableResult public func clean() -> Bool {
        
        guard isDirty else { return false }
        
        //
        //
        //
        
        var polygons: [Polygon] = []
        
        for node in footprint.nodes {
            
            for (cardinal, pointOfAccess) in node.cardinals {
                
                let (o0, o1) = cardinal.ordinals
                
                let coordinate = footprint.coordinate + node.coordinate
                
                var vector = Vector(coordinate: coordinate.xz)
                
                vector.y = 1.0
                
                let v1 = vector + o0.vector
                let v2 = vector + o1.vector
                
                let color: Color = (pointOfAccess ? .green : .blue)
                
                polygons.append(Polygon(vertices: [Vertex(position: v1, normal: .up, color: color),
                                                   Vertex(position: vector, normal: .up, color: color),
                                                   Vertex(position: v2, normal: .up, color: color)]))
            }
        }
        
        let mesh = Mesh(polygons: polygons)
        
        self.geometry = SCNGeometry(mesh: mesh)
        
        //
        //
        //
        
        isDirty = false
        
        return true
    }
}

extension Prop {
    
    public func update(delta: TimeInterval, time: TimeInterval) {
        
        //
    }
}

extension Prop {
    
    func contains(node: GridNode) -> Bool {
        
        return footprint.intersects(node: node)
    }
}
