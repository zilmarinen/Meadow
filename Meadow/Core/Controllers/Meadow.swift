//
//  Meadow.swift
//  Meadow
//
//  Created by Zack Brown on 27/04/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import SceneKit

public class Meadow: SCNScene {
    
    lazy var areas = { () -> Area in
       
        let grid = Area(delegate: self)
        
        rootNode.addChildNode(grid)
        
        return grid
    }()
    
    lazy var foliage = { () -> Foliage in
        
        let grid = Foliage(delegate: self)
        
        rootNode.addChildNode(grid)
        
        return grid
    }()
    
    lazy var footpaths = { () -> Footpath in
        
        let grid = Footpath(delegate: self)
        
        rootNode.addChildNode(grid)
        
        return grid
    }()
    
    lazy var scaffolds = { () -> Scaffold in
        
        let grid = Scaffold(delegate: self)
        
        rootNode.addChildNode(grid)
        
        return grid
    }()
    
    lazy var terrain = { () -> Terrain in
        
        let grid = Terrain(delegate: self)
        
        rootNode.addChildNode(grid)
        
        return grid
    }()
    
    lazy var tunnels = { () -> Tunnel in
        
        let grid = Tunnel(delegate: self)
        
        rootNode.addChildNode(grid)
        
        return grid
    }()
    
    lazy var water = { () -> Water in
        
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
    
    public func didBecomeDirty(node: GridNode) {
        
        //
    }
}
