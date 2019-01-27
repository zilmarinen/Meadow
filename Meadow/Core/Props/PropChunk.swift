//
//  PropChunk.swift
//  Meadow-iOS
//
//  Created by Zack Brown on 10/01/2019.
//  Copyright © 2019 Script Orchard. All rights reserved.
//

import SceneKit

public class PropChunk: SCNNode, SceneGraphChild, SceneGraphObserver, SceneGraphParent {
    
    public typealias ChildType = Prop
    
    public var observer: SceneGraphObserver?
    
    public var children: [ChildType] { return childNodes as! [ChildType] }
    
    var isDirty: Bool = false
    
    public let volume: Volume
    
    public required init(observer: SceneGraphObserver, volume: Volume) {
        
        self.observer = observer
        
        self.volume = volume
        
        super.init()
        
        self.name = "Chunk"
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
}

extension PropChunk: SceneGraphSoilable {
    
    public func becomeDirty() {
        
        if !isDirty {
            
            isDirty = true
        }
    }
    
    public func clean() {
        
        if !isDirty { return }
        
        children.forEach { prop in
            
            prop.clean()
        }
        
        isDirty = false
    }
}

extension PropChunk {
    
    public func index(of child: Prop) -> Int? {
        
        return childNodes.index(of: child)
    }
    
    public func child(didBecomeDirty child: SceneGraphChild) {
        
        becomeDirty()
        
        observer?.child(didBecomeDirty: child)
    }
}

extension PropChunk {
    
    public func add(prototype: PropPrototype, footprint: Footprint) -> Prop? {
        
        if find(prop: footprint) != nil {
        
            return nil
        }
        
        let prop = Prop(observer: self, prototype: prototype, footprint: footprint)
        
        addChildNode(prop)
        
        prop.categoryBitMask = categoryBitMask
        
        becomeDirty()
        
        return prop
    }
    
    public func find(prop footprint: Footprint) -> Prop? {
        
        return children.first { prop -> Bool in
            
            return prop.footprint.intersects(footprint: footprint)
        }
    }
    
    public func find(prop coordinate: Coordinate, edge: GridEdge) -> Prop? {
        
        return children.first { prop -> Bool in
            
            return prop.footprint.intersects(coordinate: coordinate, edge: edge)
        }
    }
    
    @discardableResult
    public func remove(prop: Prop) -> Bool {
        
        if index(of: prop) != nil {
            
            prop.removeFromParentNode()
            
            becomeDirty()
            
            return true
        }
        
        return false
    }
}

extension PropChunk: Encodable {
    
    enum CodingKeys: CodingKey {
        
        case name
        case children
    }
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(self.name, forKey: .name)
        try container.encode(self.children, forKey: .children)
    }
}
