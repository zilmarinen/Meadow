//
//  Portal.swift
//
//  Created by Zack Brown on 09/12/2020.
//

import SceneKit

public class Portal: SCNNode, Codable, Hideable, Interactive, Responder, SceneGraphNode, Soilable, Updatable {
    
    private enum CodingKeys: CodingKey {
        
        case footprint
        case identifier
    }
    
    public var ancestor: SoilableParent? { parent as? SoilableParent }
    
    public var isDirty: Bool = false
    
    public var children: [SceneGraphNode] { [] }
    public var childCount: Int { children.count }
    public var isLeaf: Bool { children.isEmpty }
    public var category: Int { SceneGraphCategory.portal.rawValue }
    
    public let footprint: Footprint
    public var identifier: String = "undefined"
    
    var pointsOfAccess: [GridNode] { footprint.nodes.map { GridNode(coordinate: $0.coordinate, cardinal: $0.cardinals.first!) } }
    var slots: [InteractionSlot] = []
    
    init(footprint: Footprint) {
        
        self.footprint = footprint
        
        super.init()
        
        name = "Portal"
        
        categoryBitMask = category
    }
    
    required public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        footprint = try container.decode(Footprint.self, forKey: .footprint)
        identifier = try container.decode(String.self, forKey: .identifier)
        
        super.init()
        
        categoryBitMask = category
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(footprint, forKey: .footprint)
        try container.encode(identifier, forKey: .identifier)
    }
}

extension Portal {
    
    @discardableResult public func clean() -> Bool {
        
        guard isDirty else { return false }
        
        //
        
        isDirty = false
        
        return true
    }
}

extension Portal {
    
    func update(delta: TimeInterval, time: TimeInterval) {
        
        //
    }
}

extension Portal {
    
    func contains(node: GridNode) -> Bool {
        
        return footprint.intersects(node: node)
    }
}
