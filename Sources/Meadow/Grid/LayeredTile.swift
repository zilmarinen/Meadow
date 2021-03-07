//
//  LayeredTile.swift
//
//  Created by Zack Brown on 26/01/2021.
//

public class LayeredTile<L: Layer>: Tile {
    
    private enum CodingKeys: CodingKey {
        
        case layers
    }
    
    var layers: [L] = []
    
    public override var children: [SceneGraphNode] { layers }
    public override var childCount: Int { children.count }
    public override var isLeaf: Bool { children.isEmpty }
    public override var category: Int { fatalError("LayeredTile.category must be overridden") }
    
    public required init(from decoder: Decoder) throws {
        
        try super.init(from: decoder)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        layers = try container.decode([L].self, forKey: .layers)
        
        for layer in layers {
            
            layer.ancestor = self
        }
    }
    
    required init(coordinate: Coordinate) {
        
        super.init(coordinate: coordinate)
    }
    
    public override func encode(to encoder: Encoder) throws {
        
        try super.encode(to: encoder)
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(layers, forKey: .layers)
    }
}

extension LayeredTile {
    
    var upperLayer: L? { layers.last }
    var lowerLayer: L? { layers.first }
    
    public func add(layer coordinate: Coordinate) -> L {
        
        let layer = L(coordinate: coordinate + Coordinate(x: 0, y: (1 * layers.count), z: 0))
        
        upperLayer?.upper = layer
        layer.lower = upperLayer
        
        layers.append(layer)
        
        layer.ancestor = self
        
        becomeDirty()
        
        return layer
    }
    
    public func find(layer index: Int) -> L? {
        
        guard index >= 0 && index < layers.count else { return nil }
        
        return layers[index]
    }
    
    public func remove(layer index: Int) {
        
        guard let layer = find(layer: index)  else { return }
        
        layer.upper?.lower = layer.lower
        layer.lower?.upper = layer.upper
        
        layer.upper = nil
        layer.lower = nil
        
        layers.remove(at: index)
        
        becomeDirty()
    }
    
    public func index(of layer: L) -> Int? {
        
        layers.firstIndex(of: layer)
    }
}
