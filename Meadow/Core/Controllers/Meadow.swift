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
    
    /*!
     @property delegate
     @abstract Delegate to inform when grid nodes become dirty.
     */
    private let delegate: GridDelegate
    
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
    
    /*!
     @method init:delegate
     @abstract Creates and initialises a grid with the specified delegate.
     @param delegate The delegate to call out to when grid becomes dirty.
     */
    public required init(delegate: GridDelegate) {
        
        self.delegate = delegate
        
        super.init()
    }
    
    /*!
     @method initWithCoder
     @abstract Support coding and decoding via NSKeyedArchiver.
     */
    public required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
}

extension Meadow: SCNSceneRendererDelegate {
    
    /*!
     @method renderer:updateAtTime:
     @abstract Called exactly once per frame before any animation and actions are evaluated and any physics are simulated.
     @param renderer The renderer that will render the scene.
     @param time The time at which to update the scene.
     */
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
        
        delegate.didBecomeDirty(node: node)
    }
}
