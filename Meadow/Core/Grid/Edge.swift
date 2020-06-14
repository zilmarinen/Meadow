//
//  Edge.swift
//  Meadow
//
//  Created by Zack Brown on 07/02/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

import Pasture

public class Edge<L: Layer>: NSObject, Soilable, Clearable, Encodable, Renderable, SceneGraphIdentifiable, SceneGraphNode, Updatable {
    
    private enum CodingKeys: CodingKey {

        case cardinal
    }
    
    public weak var ancestor: SoilableParent?
    
    public var coordinate: Coordinate
    
    public var isDirty = false
    
    public var isHidden: Bool = false {
        
        didSet {
            
            becomeDirty()
        }
    }
    
    public var name: String?
    
    var mesh: Mesh = Mesh(polygons: [])
    
    var transform: Transform { fatalError("Edge.transform must be overridden") }
    
    public let cardinal: Cardinal
    
    var layers: [L] = []
    
    required init(ancestor: SoilableParent, coordinate: Coordinate, cardinal: Cardinal) {
        
        self.ancestor = ancestor
        
        self.coordinate = coordinate
        
        self.cardinal = cardinal
        
        self.name = "Edge [\(cardinal.description)]"
    }
    
    public func encode(to encoder: Encoder) throws {
     
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(cardinal, forKey: .cardinal)
    }
    
    @discardableResult public func clean() -> Bool {
        
        guard isDirty else { return false }
        
        layers.forEach { layer in
            
            layer.clean()
        }
        
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
    }
    
    func render(transform: Transform) -> Mesh { fatalError("Edge.render must be overridden") }
    
    public var children: [SceneGraphNode] { return layers }
    
    public var childCount: Int { return children.count }
    
    public var isLeaf: Bool { return children.isEmpty }
    
    public var category: SceneGraphNodeCategory { fatalError("Edge.category must be overridden") }
    
    public var type: SceneGraphNodeType { return .edge }
}

public extension Edge {
    
    var bottomLayer: L? { return layers.first }
    var topLayer: L? { return layers.last }
    var totalLayers: Int { return layers.count }
    
    func addLayer() -> L? {
        
        if topLayer?.corners.base == World.Constants.ceiling { return nil }
        
        let layer = L(ancestor: self, coordinate: coordinate, cardinal: cardinal)
        
        layer.lower = topLayer
        topLayer?.upper = layer
        
        if let topLayer = topLayer {
            
            var peak = topLayer.corners.peak
            
            if peak < World.Constants.ceiling {
                
                peak += 1
            }
            
            layer.corners.set(elevation: peak)
        }
        
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
    
    func index(of layer: L) -> Int? {
        
        return layers.firstIndex(of: layer)
    }
}
