//
//  GridTile.swift
//  Meadow
//
//  Created by Zack Brown on 26/04/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

public class GridTile<Node: GridNode> {
    
    private var nodes: Set<Node> = []
    
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
    
    static var TileSize: Size { return Size(width: World.TileSize, height: (World.Ceiling - World.Floor), depth: World.TileSize) }
    
    static func TileCoordinate(_ coordinate: Coordinate) -> Coordinate {
        
        return Coordinate(x: coordinate.x, y: World.Floor, z: coordinate.z)
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
