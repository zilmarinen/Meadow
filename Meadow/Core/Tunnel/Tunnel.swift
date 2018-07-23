//
//  Tunnel.swift
//  Meadow
//
//  Created by Zack Brown on 01/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Foundation

public class Tunnel: Grid<TunnelChunk, TunnelTile, TunnelNode>, GridNodeTypeProvider {
    
    public typealias NodeType = TunnelType
    
    public var nodeTypes: [TunnelType] = []
    
    public required override init() {
        
        super.init()
        
        guard let nodeTypes = NodeType.load(filename: "tunnel_types") else { fatalError() }
        
        self.nodeTypes = nodeTypes
    }
    
    public required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
}

extension Tunnel {
    
    func add(node coordinate: Coordinate) -> TunnelNode? {
        
        return add(node: TunnelTile.fixedVolume(coordinate))
    }
}
