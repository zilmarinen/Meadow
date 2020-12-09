//
//  Portal.swift
//
//  Created by Zack Brown on 09/12/2020.
//

import SceneKit

public class Portal: SCNNode, Codable, Hideable, Responder, SceneGraphNode, Soilable, Updatable {
    
    private enum CodingKeys: CodingKey {
        
        
    }
    
    public var ancestor: SoilableParent? { return grid }
    
    public var isDirty: Bool = false
    
    weak var grid: Portals?
    
    public var children: [SceneGraphNode] { [] }
    public var childCount: Int { children.count }
    public var isLeaf: Bool { children.isEmpty }
    public var category: Int { SceneGraphCategory.portal.rawValue }
    
    override init() {
        
        super.init()
        
        name = "Portal"
        
        categoryBitMask = category
    }
    
    required public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        //
        
        super.init()
        
        categoryBitMask = category
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        //
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
