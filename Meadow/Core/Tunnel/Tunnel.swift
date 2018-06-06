//
//  Tunnel.swift
//  Meadow
//
//  Created by Zack Brown on 01/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Foundation

/*!
 @class Tunnel
 @abstract Tunnel is a Grid type that manages the addition and removal of TunnelNodes.
 */
public class Tunnel: Grid<TunnelChunk, TunnelTile, TunnelNode> {
 
    /*!
     @property nodeName
     @abstract Returns the name of the SceneGraphNode.
     */
    override public var nodeName: String { return "Tunnels" }
}
