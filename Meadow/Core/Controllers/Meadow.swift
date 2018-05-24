//
//  Meadow.swift
//  Meadow
//
//  Created by Zack Brown on 27/04/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import SceneKit

/*!
 @struct MeadowJSON
 @abstract
 */
public struct MeadowJSON: Decodable {
    
    /*!
     @property areas
     @abstract The areas in world.
     */
    let areas: GridJSON<GridNodeJSON>
    
    /*!
     @property foliage
     @abstract The foliage in world.
     */
    let foliage: GridJSON<GridNodeJSON>
    
    /*!
     @property footpaths
     @abstract The footpaths in world.
     */
    let footpaths: GridJSON<GridNodeJSON>
    
    /*!
     @property terrain
     @abstract The terrain in world.
     */
    let terrain: GridJSON<TerrainNodeJSON>
    
    /*!
     @property water
     @abstract The water in world.
     */
    let water: GridJSON<GridNodeJSON>
}

/*!
 @class Meadow
 @abstract Meadow is the top level parent class for all grid types.
 @discussion Meadow instantiates and manages a scene comprising various grid types.
 */

public class Meadow: SCNScene, Encodable {
    
    /*!
     @property delegate
     @abstract Delegate to inform when grid nodes become dirty.
     */
    private let delegate: GridDelegate
    
    /*!
     @property cameraJib
     @abstract Main world camera parent node.
     */
    public let cameraJib = CameraJib()
    
    /*!
     @property areas
     @abstract Area Grid type.
     */
    public let areas = Area()
    
    /*!
     @property foliage
     @abstract Foliage Grid type.
     */
    public let foliage = Foliage()
    
    /*!
     @property footpaths
     @abstract Footpath Grid type.
     */
    public let footpaths = Footpath()
    
    /*!
     @property scaffolds
     @abstract Scaffold Grid type.
     */
    public let scaffolds = Scaffold()
    
    /*!
     @property terrain
     @abstract Terrain Grid type.
     */
    public let terrain = Terrain()
    
    /*!
     @property tunnels
     @abstract Tunnel Grid type.
     */
    public let tunnels = Tunnel()
    
    /*!
     @property water
     @abstract Water Grid type.
     */
    public let water = Water()
    
    /*!
     @method init:delegate
     @abstract Creates and initialises a grid with the specified delegate.
     @param delegate The delegate to call out to when grid becomes dirty.
     */
    public required init(delegate: GridDelegate) {
        
        self.delegate = delegate
        
        super.init()
        
        areas.delegate = self
        foliage.delegate = self
        footpaths.delegate = self
        scaffolds.delegate = self
        terrain.delegate = self
        tunnels.delegate = self
        water.delegate = self
        
        terrain.loadTerrainTypes()
        
        rootNode.name = "Meadow"
        rootNode.addChildNode(cameraJib)
        rootNode.addChildNode(areas)
        rootNode.addChildNode(foliage)
        rootNode.addChildNode(footpaths)
        rootNode.addChildNode(scaffolds)
        rootNode.addChildNode(terrain)
        rootNode.addChildNode(tunnels)
        rootNode.addChildNode(water)
    }
    
    /*!
     @method initWithCoder
     @abstract Support coding and decoding via NSKeyedArchiver.
     */
    public required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
}

extension Meadow {
    
    /*!
     @enum CodingKeys
     @abstract Defines the coding keys used when encoding this object.
     */
    private enum CodingKeys: CodingKey {
        
        case areas
        case foliage
        case footpaths
        case terrain
        case water
    }
    
    /*!
     @method encode:to
     @abstract Encodes this object into the given encoder.
     @property encoder The encoder to use when encoding this object.
     */
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(areas, forKey: .areas)
        try container.encode(foliage, forKey: .foliage)
        try container.encode(footpaths, forKey: .footpaths)
        try container.encode(terrain, forKey: .terrain)
        try container.encode(water, forKey: .water)
    }
}

extension Meadow {
    
    public func load(json: MeadowJSON) {
        
        areas.clear()
        foliage.clear()
        footpaths.clear()
        scaffolds.clear()
        terrain.clear()
        tunnels.clear()
        water.clear()
        
        let terrainNodes = json.terrain.chunks.flatMap { $0.tiles.flatMap { $0.nodes } }
        
        terrainNodes.forEach { nodeJSON in
            
            guard let terrainNode = terrain.add(node: nodeJSON.volume.coordinate) else { return }
            
            nodeJSON.layers.forEach({ terrainLayerJSON in
                
                guard let terrainType = terrain.find(terrainType: terrainLayerJSON.type), let terrainLayer = terrainNode.add(layer: terrainType) else { return }
                
                for index in 0..<terrainLayerJSON.corners.count {
                    
                    terrainLayer.set(height: terrainLayerJSON.corners[index], corner: GridCorner(rawValue: index)!)
                }
            })
        }
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
