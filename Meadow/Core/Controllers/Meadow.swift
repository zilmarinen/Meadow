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
     @property name
     @abstract The name of the scene.
     */
    let name: String
    
    /*!
     @property areas
     @abstract The areas in world.
     */
    let areas: GridJSON<AreaNodeJSON>
    
    /*!
     @property foliage
     @abstract The foliage in world.
     */
    let foliage: GridJSON<GridNodeJSON>
    
    /*!
     @property footpaths
     @abstract The footpaths in world.
     */
    let footpaths: GridJSON<FootpathNodeJSON>
    
    /*!
     @property terrain
     @abstract The terrain in world.
     */
    let terrain: GridJSON<TerrainNodeJSON>
    
    /*!
     @property water
     @abstract The water in world.
     */
    let water: GridJSON<WaterNodeJSON>
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
    private let delegate: SoilableDelegate
    
    /*!
     @property lastUpdateTime
     @abstract TimeInterval of when the last update was performed.
     */
    private var lastUpdateTime: TimeInterval = -1
    
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
     @property foliageResolver
     @abstract Foliage Grid Resolver.
     */
    private let foliageResolver: FoliageResolver
    
    /*!
     @property scaffoldResolver
     @abstract Scaffold Grid Resolver.
     */
    private let scaffoldResolver: ScaffoldResolver
    
    /*!
     @property tunnelResolver
     @abstract Tunnel Grid Resolver.
     */
    private let tunnelResolver: TunnelResolver
    
    /*!
     @property waterResolver
     @abstract Water Grid Resolver.
     */
    private let waterResolver: WaterResolver
    
    /*!
     @method init:delegate
     @abstract Creates and initialises a grid with the specified delegate.
     @param delegate The delegate to call out to when grid becomes dirty.
     */
    public required init(delegate: SoilableDelegate) {
        
        self.delegate = delegate
        
        foliageResolver = FoliageResolver(foliage: foliage, terrain: terrain)
        scaffoldResolver = ScaffoldResolver(scaffolds: scaffolds, areas: areas, footpaths: footpaths, terrain: terrain)
        tunnelResolver = TunnelResolver(tunnels: tunnels, footpaths: footpaths, terrain: terrain, water: water)
        waterResolver = WaterResolver(water: water, terrain: terrain)
        
        super.init()
        
        areas.delegate = self
        foliage.delegate = self
        footpaths.delegate = self
        scaffolds.delegate = self
        terrain.delegate = self
        tunnels.delegate = self
        water.delegate = self
        
        areas.loadMaterialTypes()
        areas.loadSurfaceTypes()
        footpaths.loadFootpathTypes()
        terrain.loadTerrainTypes()
        water.loadWaterTypes()
        
        rootNode.name = "Meadow"
        rootNode.addChildNode(cameraJib)
        rootNode.addChildNode(areas)
        rootNode.addChildNode(foliage)
        rootNode.addChildNode(footpaths)
        rootNode.addChildNode(scaffolds)
        rootNode.addChildNode(terrain)
        rootNode.addChildNode(tunnels)
        rootNode.addChildNode(water)
        
        cameraJib.stateMachine.state = .focus(SCNVector3Zero, .north, (CameraJib.maximumZoomLevel / 2.0))
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
        
        case name
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
        
        try container.encode((rootNode.name ?? "Meadow"), forKey: .name)
        try container.encode(areas, forKey: .areas)
        try container.encode(foliage, forKey: .foliage)
        try container.encode(footpaths, forKey: .footpaths)
        try container.encode(terrain, forKey: .terrain)
        try container.encode(water, forKey: .water)
    }
}

extension Meadow {
    
    /*!
     @method load:json
     @abstract Load all grid types from supplied data.
     @property json MeadowJSON struct containing grid data.
     */
    public func load(json: MeadowJSON) {
        
        rootNode.name = json.name
        
        let areaNodes = json.areas.chunks.flatMap { $0.tiles.flatMap { $0.nodes } }
        let footpathNodes = json.footpaths.chunks.flatMap { $0.tiles.flatMap { $0.nodes } }
        let terrainNodes = json.terrain.chunks.flatMap { $0.tiles.flatMap { $0.nodes } }
        let waterNodes = json.water.chunks.flatMap { $0.tiles.flatMap { $0.nodes } }
        
        areas.load(nodes: areaNodes)
        footpaths.load(nodes: footpathNodes)
        terrain.load(nodes: terrainNodes)
        water.load(nodes: waterNodes)
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
        
        let deltaTime = (lastUpdateTime == -1 ? 0 : (time - lastUpdateTime))
        
        cameraJib.update(deltaTime: deltaTime)
        
        areas.update(deltaTime: deltaTime)
        foliage.update(deltaTime: deltaTime)
        footpaths.update(deltaTime: deltaTime)
        scaffolds.update(deltaTime: deltaTime)
        terrain.update(deltaTime: deltaTime)
        tunnels.update(deltaTime: deltaTime)
        water.update(deltaTime: deltaTime)
        
        foliageResolver.resolve()
        scaffoldResolver.resolve()
        tunnelResolver.resolve()
        waterResolver.resolve()
        
        lastUpdateTime = time
    }
}

extension Meadow: SoilableDelegate {
    
    /*!
     @method didBecomeDirty:volume
     @abstract Callback for soilable item to delegate change resolution upwards.
     @param soilable The Soilable object that became dirty.
     */
    public func didBecomeDirty(soilable: Soilable) {
        
        guard let node = soilable as? SceneGraphNode else { return }
        
        let volume = node.volume
        
        switch type(of: soilable) {
            
        case is AreaNode.Type:
            
            scaffoldResolver.enqueue(volume: volume)
            
        case is FootpathNode.Type:
            
            scaffoldResolver.enqueue(volume: volume)
            tunnelResolver.enqueue(volume: volume)
            
        case is TerrainNode.Type:
            
            foliageResolver.enqueue(volume: volume)
            scaffoldResolver.enqueue(volume: volume)
            tunnelResolver.enqueue(volume: volume)
            waterResolver.enqueue(volume: volume)
            
        case is WaterNode.Type:
            
            tunnelResolver.enqueue(volume: volume)
            waterResolver.enqueue(volume: volume)
            
        default: break
        }
        
        delegate.didBecomeDirty(soilable: soilable)
    }
}
