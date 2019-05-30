//
//  Props.swift
//  Meadow
//
//  Created by Zack Brown on 12/11/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import SceneKit

public class Props: SCNNode, SceneGraphChild, SceneGraphObserver, SceneGraphParent {
    
    var children = Tree<Prop>()
    
    public var observer: SceneGraphObserver?
    
    var isDirty: Bool = false
    
    public override var isHidden: Bool {
        
        didSet {
            
            if isHidden != oldValue {
                
                becomeDirty()
            }
        }
    }
    
    public var volume: Volume { return Volume(coordinate: Coordinate.zero, size: Size.one) }
    
    public override func addChildNode(_ child: SCNNode) {
        
        guard let child = child as? Prop else { return }
        
        if children.append(child) {
            
            super.addChildNode(child)
            
            becomeDirty()
        }
    }
}

extension Props: Encodable {
    
    enum CodingKeys: CodingKey {
        
        case name
        case children
    }
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(self.name, forKey: .name)
        try container.encode(self.children.children, forKey: .children)
    }
}

extension Props: SceneGraphUpdatable {
    
    public func update(deltaTime: TimeInterval) {
        
        clean()
    }
}

extension Props {
    
    public var totalChildren: Int { return children.count }
    
    public func child(at index: Int) -> SceneGraphChild? {
        
        return children[index]
    }
    
    public func index(of child: SceneGraphChild) -> Int? {
        
        guard let child = child as? Prop else { return nil }
        
        return children.index(of: child)
    }
}

extension Props: SceneGraphSoilable {
    
    @discardableResult public func becomeDirty() -> Bool {
        
        if !isDirty {
            
            isDirty = true
        }
        
        return isDirty
    }
    
    @discardableResult public func clean() -> Bool {
        
        if !isDirty { return false }
        
        children.forEach { chunk in
            
            chunk.clean()
        }
        
        isDirty = false
        
        return true
    }
}

extension Props {
    
    public func child(didBecomeDirty child: SceneGraphChild) {
        
        becomeDirty()
        
        observer?.child(didBecomeDirty: child)
    }
}

extension Props: SceneGraphIntermediate {
    
    public typealias IntermediateType = PropIntermediate
    
    func load(intermediates: [IntermediateType]) {
        
        intermediates.forEach { intermediate in
            
            //
        }
    }
}

extension Props {
    
    public func add(prototype: PropPrototype, coordinate: Coordinate, rotation: GridEdge) -> Prop? {
        
        if coordinate.y < World.floor || coordinate.y > World.ceiling {
            
            return nil
        }
        
        let footprint = Footprint(coordinate: coordinate, rotation: rotation, nodes: prototype.footprint.nodes)
        
        if find(prop: footprint) != nil {
            
            return nil
        }
        
        let prop = Prop(observer: self, prototype: prototype, footprint: footprint)
        
        addChildNode(prop)
        
        prop.categoryBitMask = categoryBitMask
        
        becomeDirty()
        
        return prop
    }
    
    public func find(prop coordinate: Coordinate, edge: GridEdge) -> Prop? {
        
        return children.first { prop -> Bool in
            
            return prop.footprint.intersects(coordinate: coordinate, edge: edge)
        }
    }
    
    public func find(prop footprint: Footprint) -> Prop? {
        
        return children.first { prop -> Bool in
            
            return prop.footprint.intersects(footprint: footprint)
        }
    }
    
    @discardableResult public func remove(prop: Prop) -> Bool {
        
        if index(of: prop) != nil {
            
            prop.removeFromParentNode()
            
            prop.observer = nil
            
            children.remove(prop)
            
            becomeDirty()
            
            return true
        }
        
        return false
    }
}
