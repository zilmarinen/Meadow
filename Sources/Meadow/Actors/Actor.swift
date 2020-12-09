//
//  Actor.swift
//
//  Created by Zack Brown on 09/12/2020.
//

import SceneKit

public class Actor: SCNNode, Codable, Hideable, Responder, SceneGraphNode, Soilable, Updatable {
    
    private enum CodingKeys: CodingKey {
        
        
    }
    
    public var ancestor: SoilableParent? { return grid }
    
    public var isDirty: Bool = false
    
    weak var grid: Actors?
    
    public var children: [SceneGraphNode] { [] }
    public var childCount: Int { children.count }
    public var isLeaf: Bool { children.isEmpty }
    public var category: Int { SceneGraphCategory.actor.rawValue }
    
    override init() {
        
        super.init()
        
        name = "Actor"
        
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

extension Actor {
    
    @discardableResult public func clean() -> Bool {
        
        guard isDirty else { return false }
        
        //
        
        isDirty = false
        
        return true
    }
}

extension Actor {
    
    func update(delta: TimeInterval, time: TimeInterval) {
        
        //
    }
}
