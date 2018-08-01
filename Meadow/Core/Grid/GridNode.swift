//
//  GridNode.swift
//  Meadow
//
//  Created by Zack Brown on 26/04/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

public class GridNode: GridChild, GridMeshProvider, GridSoilable, Encodable {
    
    public var observer: GridObserver?
    
    public var name: String? { return "Node" }
    
    public var isHidden: Bool = false
    
    public let volume: Volume
    
    var isDirty: Bool = true
    
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
    
    public required init(observer: GridObserver, volume: Volume) {
        
        self.observer = observer
        
        self.volume = volume
    }
    
    open func becomeDirty() {
        
        if !isDirty {
            
            isDirty = true
            
            observer?.child(didBecomeDirty: self)
        }
    }
    
    open func clean() {}
    
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
    
    func find(neighbour edge: GridEdge) -> GridNode.Neighbour? {
        
        switch edge {
            
        case .north: return neighbours.north
        case .east: return neighbours.east
        case .south: return neighbours.south
        case .west: return neighbours.west
        }
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
