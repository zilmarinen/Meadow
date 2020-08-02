//
//  Layer.swift
//  Meadow
//
//  Created by Zack Brown on 07/02/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

import Foundation

public class Layer: NSObject, Soilable, Clearable, Encodable, Hideable, SceneGraphIdentifiable, SceneGraphNode, Updatable {
    
    private enum CodingKeys: CodingKey {
        
        case identifier
        case corners
    }
    
    public weak var ancestor: SoilableParent?
    
    public var isDirty = false
    
    public var isHidden: Bool = false {
        
        didSet {
            
            guard oldValue != isHidden else { return }
            
            becomeDirty()
        }
    }
    
    public var name: String?
    
    public let identifier: Int
    
    public var upper: Layer? {
        
        didSet {
            
            guard oldValue != upper else { return }
            
            becomeDirty()
        }
    }
    
    public var lower: Layer? {
        
        didSet {
            
            guard oldValue != lower else { return }
            
            becomeDirty()
        }
    }
    
    public var corners = LayerCorners()
    
    required init(ancestor: SoilableParent, identifier: Int) {
        
        self.ancestor = ancestor
        
        self.identifier = identifier
        
        self.name = "Layer"
    }
    
    public func encode(to encoder: Encoder) throws {
     
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(identifier, forKey: .identifier)
        try container.encode(corners, forKey: .corners)
    }
    
    @discardableResult public func clean() -> Bool {
        
        guard isDirty else { return false }
        
        isDirty = false
        
        return true
    }
    
    func clear() {}
    
    func update(delta: TimeInterval, time: TimeInterval) {}
    
    public var children: [SceneGraphNode] { return [] }
    
    public var childCount: Int { return children.count }
    
    public var isLeaf: Bool { return children.isEmpty }
    
    public var category: SceneGraphNodeCategory { fatalError("Layer.category must be overridden") }
    
    public var type: SceneGraphNodeType { return .layer }
}

public extension Layer {
    
    func get(elevation corner: LayerCorners.Anchor) -> Int {
        
        switch corner {
            
        case .left: return corners.left.elevation
        case .right: return corners.right.elevation
        case .centre: return corners.centre.elevation
        }
    }
    
    func set(elevation: Int) {
        
        corners.set(elevation: elevation)
        
        becomeDirty()
    }
    
    func set(elevation: Int, corner: LayerCorners.Anchor) {
        
        switch corner {
            
        case .left: corners.left.elevation = elevation
        case .right: corners.right.elevation = elevation
        case .centre: corners.centre.elevation = elevation
        }
        
        becomeDirty()
    }
}
