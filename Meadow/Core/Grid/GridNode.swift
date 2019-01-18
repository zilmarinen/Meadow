//
//  GridNode.swift
//  Meadow
//
//  Created by Zack Brown on 26/04/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

public class GridNode: Encodable, GridMeshProvider, SceneGraphChild, SceneGraphObserver, SceneGraphSoilable {
    
    public var observer: SceneGraphObserver?
    
    public var name: String? { return "Node" }
    
    public var isHidden: Bool = false {
        
        didSet {
            
            if isHidden != oldValue {
                
                becomeDirty()
            }
        }
    }
    
    public let volume: Volume
    
    var isDirty: Bool = false
    
    var neighbours = Neighbours()
    
    private enum CodingKeys: CodingKey {
        
        case name
        case volume
    }
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(self.name, forKey: .name)
        try container.encode(self.volume, forKey: .volume)
    }
    
    public required init(observer: SceneGraphObserver, volume: Volume) {
        
        self.observer = observer
        
        self.volume = volume
    }
    
    open func becomeDirty() {
        
        if !isDirty {
            
            isDirty = true
            
            observer?.child(didBecomeDirty: self)
        }
    }
    
    open func clean() {
        
        if !isDirty { return }
        
        isDirty = false
    }
    
    open func child(didBecomeDirty child: SceneGraphChild) {
        
        let _ = becomeDirty()
        
        observer?.child(didBecomeDirty: child)
    }
    
    open var mesh: Mesh { return Mesh(faces: []) }
}

extension GridNode {
    
    func add(neighbour node: GridNode, edge: GridEdge) {
        
        guard node.volume.coordinate.adjacency(to: volume.coordinate) == .adjacent else { return }
        
        let _ = remove(neighbour: edge)
        
        let neighbour = Neighbour(edge: edge, node: node)
        
        switch edge {
            
        case .north: neighbours.north = neighbour
        case .east: neighbours.east = neighbour
        case .south: neighbours.south = neighbour
        case .west: neighbours.west = neighbour
        }
        
        let oppositeEdge = GridEdge.opposite(edge: edge)
        
        if node.find(neighbour: oppositeEdge) == nil {
            
            node.add(neighbour: self, edge: oppositeEdge)
        }
        
        becomeDirty()
    }
    
    public func find(neighbour edge: GridEdge) -> GridNode.Neighbour? {
        
        return neighbours.find(edge: edge)
    }
    
    func remove(neighbour edge: GridEdge) -> Bool {
        
        guard let neighbour = find(neighbour: edge) else { return false }
        
        switch edge {
            
        case .north: neighbours.north = nil
        case .east: neighbours.east = nil
        case .south: neighbours.south = nil
        case .west: neighbours.west = nil
        }
        
        let oppositeEdge = GridEdge.opposite(edge: edge)
        
        if let _ = neighbour.node.find(neighbour: oppositeEdge) {
            
            let _ = neighbour.node.remove(neighbour: oppositeEdge)
        }
        
        becomeDirty()
        
        return true
    }
}

extension GridNode: Hashable {
    
    public var hashValue: Int { return volume.hashValue }
    
    public static func == (lhs: GridNode, rhs: GridNode) -> Bool {
        
        return lhs.volume == rhs.volume
    }
}
