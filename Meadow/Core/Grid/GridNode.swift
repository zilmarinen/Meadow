//
//  GridNode.swift
//  Meadow
//
//  Created by Zack Brown on 26/04/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

public class GridNode: GridChild, GridMeshProvider, GridSoilable, Encodable {
    
    public var observer: GridObserver?
    
    public var name: String? { return "" }
    
    public let volume: Volume
    
    var isDirty: Bool = true
    
    var neighbours: [Neighbour] = []
    
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
    
    public var mesh: Mesh { return Mesh(faces: []) }
}

extension GridNode {
    
    func add(neighbour node: GridNode, edge: GridEdge) {
        
        guard node.volume.coordinate.adjacency(to: volume.coordinate) == .adjacent else { return }
        
        let _ = remove(neighbour: edge)
        
        neighbours.append(Neighbour(edge: edge, node: node))
        
        let oppositeEdge = GridEdge.Opposite(edge: edge)
        
        if node.find(neighbour: oppositeEdge) == nil {
            
            node.add(neighbour: self, edge: oppositeEdge)
        }
        
        becomeDirty()
    }
    
    func find(neighbour edge: GridEdge) -> GridNode.Neighbour? {
        
        return neighbours.first { neighbour -> Bool in
            
            return neighbour.edge == edge
        }
    }
    
    func remove(neighbour edge: GridEdge) -> Bool {
        
        guard let neighbour = find(neighbour: edge) else { return false }
        
        if let index = neighbours.index(of: neighbour) {
            
            neighbours.remove(at: index)
        }
        
        let oppositeEdge = GridEdge.Opposite(edge: edge)
        
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
