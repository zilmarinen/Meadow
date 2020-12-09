//
//  Prop.swift
//
//  Created by Zack Brown on 07/12/2020.
//

import SceneKit

public class Prop: SCNNode, Codable, Hideable, Responder, SceneGraphNode, Soilable, Updatable {
    
    private enum CodingKeys: CodingKey {
        
        case footprint
    }
    
    public var ancestor: SoilableParent? { return grid }
    
    public var isDirty: Bool = false
    
    weak var grid: Props?
    public var coordinate: Coordinate { footprint.coordinate }
    public let footprint: Footprint
    
    public var children: [SceneGraphNode] { [] }
    public var childCount: Int { children.count }
    public var isLeaf: Bool { children.isEmpty }
    public var category: Int { SceneGraphCategory.prop.rawValue }
    
    init(footprint: Footprint) {
        
        self.footprint = footprint
        
        super.init()
        
        name = "Prop \(self.coordinate.description)"
        position = SCNVector3(coordinate: self.coordinate)
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
        
        isDirty = false
        
        return true
    }
}

extension Prop {
    
    func update(delta: TimeInterval, time: TimeInterval) {
        
        //
    }
}

extension Prop {
    
    func contains(node: GridNode) -> Bool {
        
        return footprint.intersects(node: node)
    }
}
