//
//  GridChunk.swift
//  Meadow
//
//  Created by Zack Brown on 26/04/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import SceneKit

public class GridChunk<Tile: GridTile<Node>, Node: GridNode>: SCNNode, Soilable {
    
    public var isDirty: Bool = false
    
    private var tiles: Set<Tile> = []

    let volume: Volume
    
    var isEmpty: Bool { return tiles.isEmpty }
    
    public required init(volume: Volume) {
        
        self.volume = volume
        
        super.init()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
}

extension GridChunk {
    
    public func clean() {
        
        if isDirty {
            
            tiles.forEach { tile in
                
                tile.clean()
            }
        }
    }
}

extension GridChunk {
    
    func add(tile: Tile) {
        
        if let _ = find(tile: tile.volume.coordinate) {
            
            return
        }
        
        tiles.insert(tile)
    }
    
    func remove(tile: Tile) {
        
        tiles.remove(tile)
    }
    
    func find(tile coordinate: Coordinate) -> Tile? {
        
        return tiles.first { tile -> Bool in
            
            return tile.volume.coordinate.adjacency(to: coordinate) == .equal
        }
    }
}
