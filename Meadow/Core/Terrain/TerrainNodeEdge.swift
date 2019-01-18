//
//  TerrainNodeEdge.swift
//  Meadow
//
//  Created by Zack Brown on 15/01/2019.
//  Copyright © 2019 Script Orchard. All rights reserved.
//

public class TerrainNodeEdge: SceneGraphChild, SceneGraphObserver, SceneGraphParent {
    
    public typealias ChildType = TerrainEdgeLayer
    
    public var observer: SceneGraphObserver?
    
    public var children: [ChildType] = []
    
    public var name: String? { return "Edge" }
    
    public var isHidden: Bool = false {
        
        didSet {
            
            if isHidden != oldValue {
                
                becomeDirty()
            }
        }
    }
    
    public let volume: Volume
    
    let edge: GridEdge
    
    var isDirty: Bool = false
    
    public required init(observer: SceneGraphObserver, volume: Volume, edge: GridEdge) {
        
        self.observer = observer
        
        self.volume = volume
        
        self.edge = edge
    }
}

extension TerrainNodeEdge: Hashable {
    
    public var hashValue: Int { return volume.hashValue }
    
    public static func == (lhs: TerrainNodeEdge, rhs: TerrainNodeEdge) -> Bool {
        
        return lhs.volume == rhs.volume
    }
}

extension TerrainNodeEdge: SceneGraphSoilable {
    
    public func becomeDirty() {
        
        if !isDirty {
            
            isDirty = true
            
            observer?.child(didBecomeDirty: self)
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

extension TerrainNodeEdge {
    
    public func index(of child: ChildType) -> Int? {
        
        return children.index(of: child)
    }
    
    public func child(didBecomeDirty child: SceneGraphChild) {
        
        let _ = becomeDirty()
        
        observer?.child(didBecomeDirty: child)
    }
}

extension TerrainNodeEdge {
    
    func add(layer terrainType: TerrainType) -> TerrainEdgeLayer? {
        
        let edgeLayer = TerrainEdgeLayer(observer: self, coordinate: self.volume.coordinate, edge: self.edge)
        
        topLayer?.upper = edgeLayer
        
        edgeLayer.lower = topLayer
        
        children.append(edgeLayer)
        
        becomeDirty()
        
        return edgeLayer
    }
    
    func remove(layer: TerrainEdgeLayer) -> Bool {
        
        if let index = index(of: layer) {
            
            let upper = layer.upper
            let lower = layer.lower
            
            upper?.lower = lower
            
            lower?.upper = upper
            
            layer.upper = nil
            layer.lower = nil
            
            children.remove(at: index)
            
            layer.observer = nil
            
            becomeDirty()
            
            return true
        }
        
        return false
    }
}

extension TerrainNodeEdge {
    
    var topLayer: TerrainEdgeLayer? {
        
        return children.last
    }
}

extension TerrainNodeEdge: Encodable {
    
    enum CodingKeys: CodingKey {
        
        case edge
    }
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(self.edge, forKey: .edge)
    }
}
