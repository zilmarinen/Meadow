//
//  Edge.swift
//  Meadow
//
//  Created by Zack Brown on 07/02/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

import Pasture

public class Edge<L: Layer>: Soilable, Clearable, Encodable, Renderable, Updatable {
    
    private enum CodingKeys: CodingKey {
        
        case name
        case cardinal
    }
    
    internal weak var ancestor: SoilableParent?
    
    internal var isDirty = false
    
    var isHidden: Bool = false
    
    var name: String?
    
    var mesh: Mesh?
    
    let cardinal: Cardinal
    
    var layers: [L] = []
    
    required init(ancestor: SoilableParent, cardinal: Cardinal) {
        
        self.ancestor = ancestor
        
        self.cardinal = cardinal
    }
    
    public func encode(to encoder: Encoder) throws {
     
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encodeIfPresent(name, forKey: .name)
        try container.encode(cardinal, forKey: .cardinal)
    }
    
    @discardableResult func clean() -> Bool {
        
        guard isDirty else { return false }
        
        mesh = render(transform: .identity)
        
        isDirty = false
        
        return true
    }
    
    func clear() {
        
        while(layers.count > 0) {
            
            let layer = layers.removeLast()
            
            layer.clear()
        }
    }
    
    func update(delta: TimeInterval, time: TimeInterval) {
        
        layers.forEach { layer in
            
            layer.update(delta: delta, time: time)
        }
        
        clean()
    }
    
    func render(transform: Transform) -> Mesh { return Mesh(polygons: []) }
}

extension Edge {
    
    typealias LayerConfiguration = ((L) -> Void)
    
    var bottomLayer: L? { return layers.first }
    var topLayer: L? { return layers.last }
    var totalLayers: Int { return layers.count }
    
    @discardableResult
    func add(layer configurator: Layer.Configurator) -> L? {
        
        if topLayer?.base == World.Constants.ceiling { return nil }
        
        let layer = L(ancestor: self, cardinal: cardinal)
        
        layer.lower = topLayer
        topLayer?.upper = layer
        
        if let topLayer = topLayer {
            
            let (o1, o2) = Cardinal.ordinals(cardinal: cardinal)
            
            var peak = topLayer.peak
            
            if peak < World.Constants.ceiling {
                
                peak += 1
            }
            
            layer.set(ordinal: o1, elevation: peak)
            layer.set(ordinal: o2, elevation: peak)
            layer.set(center: peak)
        }
        
        configurator(layer)
        
        layers.append(layer)
        
        topLayer?.becomeDirty()
        
        becomeDirty()
        
        return layer
    }
    
    func find(layer atIndex: Int) -> L? {
        
        guard atIndex >= 0 && atIndex < layers.count else { return nil }
        
        return layers[atIndex]
    }
    
    func remove(layer atIndex: Int) {
        
        if let layer = find(layer: atIndex) {
            
            let upper = layer.upper
            let lower = layer.lower
            
            lower?.upper = upper
            upper?.lower = lower
            
            layers.remove(at: atIndex)
            
            upper?.becomeDirty()
            lower?.becomeDirty()
            
            becomeDirty()
        }
    }
}
