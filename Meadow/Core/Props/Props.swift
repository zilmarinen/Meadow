//
//  Props.swift
//  Meadow
//
//  Created by Zack Brown on 12/11/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import SceneKit

public class Props: SCNNode, SceneGraphChild, SceneGraphParent, GridObserver {
    
    public typealias ChildType = PropChunk
    
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
        
        children.forEach { chunk in
            
            chunk.clean()
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
    
    public func child(didBecomeDirty child: SceneGraphChild) {
        
        let _ = becomeDirty()
        
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
        
        if let _ = find(prop: footprint) {
            
            return nil
        }
        
        let chunk = find(chunk: coordinate) ?? PropChunk(observer: self, volume: GridChunk.fixedVolume(coordinate))
        
        guard let prop = chunk.add(prototype: prototype, footprint: footprint) else { return nil }
        
        if chunk.parent == nil {
            
            addChildNode(chunk)
            
            chunk.categoryBitMask = categoryBitMask
            
            becomeDirty()
        }
        
        return prop
    }
    
    public func find(chunk coordinate: Coordinate) -> ChildType? {
        
        return children.first { chunk -> Bool in
            
            return chunk.volume.contains(coordinate: coordinate)
        }
    }
    
    public func find(prop footprint: Footprint) -> Prop? {
        
        if let chunk = find(chunk: footprint.coordinate), let prop = chunk.find(prop: footprint) {
            
            return prop
        }
        
        return nil
    }
    
    public func find(prop coordinate: Coordinate, edge: GridEdge) -> Prop? {
        
        if let chunk = find(chunk: coordinate), let prop = chunk.find(prop: coordinate, edge: edge) {
            
            return prop
        }
        
        return nil
    }
    
    public func remove(chunk: ChildType) -> Bool {
        
        if let _ = index(of: chunk) {
            
            chunk.removeFromParentNode()
            
            chunk.observer = nil
            
            while chunk.totalChildren > 0 {
                
                let _ = chunk.remove(prop: chunk.child(at: 0) as! Prop)
            }
            
            becomeDirty()
            
            return true
        }
        
        return false
    }
    
    public func remove(prop: Prop) -> Bool {
        
        if let chunk = find(chunk: prop.footprint.coordinate) {
            
            if chunk.remove(prop: prop) {
                
                if chunk.totalChildren == 0 {
                    
                    let _ = remove(chunk: chunk)
                }
                
                return true
            }
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
