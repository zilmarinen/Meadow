//
//  Props.swift
//  Meadow
//
//  Created by Zack Brown on 12/11/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import SceneKit

public class Props: SCNNode, SceneGraphChild, SceneGraphParent {
    
    public typealias ChildType = Prop
    
    public var children: [ChildType] { return childNodes as! [ChildType] }
    
    var isDirty: Bool = false
    
    var observer: GridObserver?
}

extension Props: SceneGraphSoilable {
    
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

extension Props {
    
    public var totalChildren: Int { return childNodes.count }
    
    public func child(at index: Int) -> SceneGraphChild? {
        
        return childNodes[index] as? SceneGraphChild
    }
    
    public func index(of child: SceneGraphChild) -> Int? {
        
        guard let child = child as? SCNNode else { return nil }
        
        return childNodes.index(of: child)
    }
}

extension Props: SceneGraphIntermediate {
    
    public typealias IntermediateType = PropIntermediate
    
    func load(intermediates: [PropIntermediate]) {
        
        intermediates.forEach { intermediate in
            
            //
        }
    }
}

extension Props {
    
    public func add(prototype: PropPrototype, coordinate: Coordinate) -> Prop? {
        
        return nil
    }
    
    public func find(prop coordinate: Coordinate, edge: GridEdge) -> Prop? {
        
        return nil
    }
    
    public func remove(prop: Prop) -> Bool {
        
        if let _ = index(of: prop) {
            
            prop.removeFromParentNode()
            
            //
        }
        
        return false
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
        try container.encode(self.children, forKey: .children)
    }
}
