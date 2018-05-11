//
//  Meadow.swift
//  Meadow
//
//  Created by Zack Brown on 27/04/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import SceneKit

/*!
 @class Meadow
 @abstract Meadow is the top level parent class for all grid types.
 @discussion Meadow instantiates and manages a scene comprising various grid types.
 */
public class Meadow: SCNScene {
    
    public lazy var areas = { () -> Area in
       
        let grid = Area(delegate: self)
        
        rootNode.addChildNode(grid)
        
        return grid
    }()
    
    public lazy var foliage = { () -> Foliage in
        
        let grid = Foliage(delegate: self)
        
        rootNode.addChildNode(grid)
        
        return grid
    }()
    
    public lazy var footpaths = { () -> Footpath in
        
        let grid = Footpath(delegate: self)
        
        rootNode.addChildNode(grid)
        
        return grid
    }()
    
    public lazy var scaffolds = { () -> Scaffold in
        
        let grid = Scaffold(delegate: self)
        
        rootNode.addChildNode(grid)
        
        return grid
    }()
    
    public lazy var terrain = { () -> Terrain in
        
        let grid = Terrain(delegate: self)
        
        rootNode.addChildNode(grid)
        
        return grid
    }()
    
    public lazy var tunnels = { () -> Tunnel in
        
        let grid = Tunnel(delegate: self)
        
        rootNode.addChildNode(grid)
        
        return grid
    }()
    
    public lazy var water = { () -> Water in
        
        let grid = Water(delegate: self)
        
        rootNode.addChildNode(grid)
        
        return grid
    }()
}

extension Meadow: SCNSceneRendererDelegate {
    
    public func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        
        areas.clean()
        foliage.clean()
        footpaths.clean()
        scaffolds.clean()
        terrain.clean()
        tunnels.clean()
        water.clean()
    }
}

extension Meadow: GridDelegate {
    
    /*!
     @method didBecomeDirty:node
     @abstract GridDelegate callback to delegate grid node resultion upwards.
     @discussion As a means to update the grid in which the node is contained, resolution of dirty nodes must be passed upwards to inform the delegate of any changes.
     */
    public func didBecomeDirty(node: GridNode) {
        
        switch type(of: node) {
            
        case is TerrainNode.Type:
            
            break
            
        default: break
        }
    }
}
