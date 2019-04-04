//
//  Props.swift
//  Meadow
//
//  Created by Zack Brown on 12/11/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import SceneKit

public class Props: SCNNode, SceneGraphChild, SceneGraphObserver, SceneGraphParent {
    
    var children = Tree<PropChunk>()
    
    public var observer: SceneGraphObserver?
    
    var isDirty: Bool = false
    
    public var volume: Volume { return Volume(coordinate: Coordinate.zero, size: Size.one) }
}

extension Props {
    
    public var totalChildren: Int { return children.count }
    
    public func child(at index: Int) -> SceneGraphChild? {
        
        return children[index]
    }
    
    public func index(of child: SceneGraphChild) -> Int? {
        
        guard let child = child as? PropChunk else { return nil }
        
        return children.index(of: child)
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
        
        let chunk = find(chunk: coordinate) ?? PropChunk(observer: self, volume: GridChunk.fixedVolume(coordinate))
        
        guard let prop = chunk.add(prototype: prototype, footprint: footprint) else { return nil }
        
        if chunk.parent == nil {
            
            addChildNode(chunk)
            
            chunk.categoryBitMask = categoryBitMask
            
            becomeDirty()
        }
        
        return prop
    }
    
    public func find(chunk coordinate: Coordinate) -> PropChunk? {
        
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
    
    @discardableResult public func remove(chunk: PropChunk) -> Bool {
        
        if index(of: chunk) != nil {
            
            chunk.removeFromParentNode()
            
            chunk.observer = nil
            
            while let prop = chunk.children.first {
                
                chunk.remove(prop: prop)
            }
            
            children.remove(chunk)
            
            becomeDirty()
            
            return true
        }
        
        return false
    }
    
    @discardableResult public func remove(prop: Prop) -> Bool {
        
        if let chunk = find(chunk: prop.footprint.coordinate) {
            
            if chunk.remove(prop: prop) {
                
                if chunk.totalChildren == 0 {
                    
                    remove(chunk: chunk)
                }
                
                return true
            }
        }
        
        return false
    }
}
