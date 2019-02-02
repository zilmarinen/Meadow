//
//  Tunnel.swift
//  Meadow
//
//  Created by Zack Brown on 01/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Foundation

public class Tunnel: Grid<TunnelChunk, TunnelTile, TunnelNode> {
    
}

extension Tunnel {
    
    func add(node coordinate: Coordinate) -> TunnelNode? {
        
        return add(node: TunnelTile.fixedVolume(coordinate))
    }
}
