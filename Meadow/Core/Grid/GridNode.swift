//
//  GridNode.swift
//  Meadow
//
//  Created by Zack Brown on 26/04/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

public class GridNode: Encodable, MeshProvider, SceneGraphChild, SceneGraphObserver, SceneGraphSoilable {
    
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
    
    var neighbours = Tree<GridNodeNeighbour>()
    
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
    
    @discardableResult open func becomeDirty() -> Bool {
        
        if !isDirty {
            
            isDirty = true
            
            observer?.child(didBecomeDirty: self)
        }
        
        return isDirty
    }
    
    @discardableResult open func clean() -> Bool {
        
        if !isDirty { return false }
        
        isDirty = false
        
        return true
    }
    
    open func child(didBecomeDirty child: SceneGraphChild) {
        
        becomeDirty()
        
        observer?.child(didBecomeDirty: child)
    }
    
    open var mesh: Mesh { return Mesh(faces: []) }
}

extension GridNode: Hashable {
    
    public var hashValue: Int { return volume.hashValue }
    
    public static func == (lhs: GridNode, rhs: GridNode) -> Bool {
        
        return lhs.volume == rhs.volume
    }
}

extension GridNode {
    
    func add(neighbour node: GridNode, edge: GridEdge) {
        
        guard find(neighbour: edge)?.node != node else { return }
        
        guard node.volume.coordinate.adjacency(to: volume.coordinate) == .adjacent else { return }
        
        remove(neighbour: edge)
        
        let neighbour = GridNodeNeighbour(edge: edge, node: node)
        
        neighbours.append(neighbour)
        
        let oppositeEdge = GridEdge.opposite(edge: edge)
        
        if node.find(neighbour: oppositeEdge)?.node != self {
            
            node.add(neighbour: self, edge: oppositeEdge)
        }
        
        becomeDirty()
    }
    
    public func find(neighbour edge: GridEdge) -> GridNodeNeighbour? {
        
        return neighbours.first { $0.edge == edge }
    }
    
    @discardableResult
    func remove(neighbour edge: GridEdge) -> Bool {
        
        guard let neighbour = find(neighbour: edge) else { return false }
        
        neighbours.remove(neighbour)
        
        let oppositeEdge = GridEdge.opposite(edge: edge)
        
        if neighbour.node.find(neighbour: oppositeEdge) != nil {
            
            neighbour.node.remove(neighbour: oppositeEdge)
        }
        
        becomeDirty()
        
        return true
    }
}
