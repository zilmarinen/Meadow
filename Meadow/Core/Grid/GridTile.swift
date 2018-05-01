//
//  GridTile.swift
//  Meadow
//
//  Created by Zack Brown on 26/04/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

public class GridTile<Node: GridNode>: Soilable {
    
    public var isDirty: Bool = false
    
    private var nodes: Set<Node> = []
    
    private var neighbours: [Node] = []
    
    let volume: Volume
    
    var isEmpty: Bool { return nodes.isEmpty }
    
    public required init(volume: Volume) {
        
        self.volume = volume
    }
}

extension GridTile: Hashable {
    
    public static func == (lhs: GridTile<Node>, rhs: GridTile<Node>) -> Bool {
        
        return lhs.volume == rhs.volume
    }
    
    public var hashValue: Int {
        
        return volume.hashValue
    }
}

extension GridTile {
    
    public func clean() {
        
        if isDirty {
            
            nodes.forEach { node in
                
                node.clean()
            }
        }
    }
}

extension GridTile {
    
    func add(node: Node) {
        
        if let _ = find(node: node.volume.coordinate) {
            
            return
        }
        
        nodes.insert(node)
    }
    
    func remove(node: Node) {
        
        nodes.remove(node)
    }
    
    func find(node coordinate: Coordinate) -> Node? {
        
        return nodes.first { node -> Bool in
            
            return node.volume.contains(coordinate: coordinate)
        }
    }
}


