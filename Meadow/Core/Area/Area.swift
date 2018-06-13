//
//  Area.swift
//  Meadow
//
//  Created by Zack Brown on 01/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

/*!
 @class Area
 @abstract Area is a Grid type that manages the addition and removal of AreaNodes.
 */
public class Area: Grid<AreaChunk, AreaTile, AreaNode> {
    
    /*!
     @property nodeName
     @abstract Returns the name of the SceneGraphNode.
     */
    override public var nodeName: String { return "Areas" }
    
    /*!
     @property surfaceTypes
     @abstract Array of AreaSurfaceTypes loaded from disc.
     */
    var surfaceTypes: [AreaSurfaceType] = []
    
    /*!
     @property availableSurfaceTypes
     @abstract Returns a reference to the AreaSurfaceTypes currently loaded.
     */
    public var availableSurfaceTypes: [AreaSurfaceType] {
        
        return surfaceTypes
    }
    
    /*!
     @property materialTypes
     @abstract Array of AreaMaterialTypes loaded from disc.
     */
    var materialTypes: [AreaMaterialType] = []
    
    /*!
     @property availableMaterialTypes
     @abstract Returns a reference to the AreaMaterialTypes currently loaded.
     */
    public var availableMaterialTypes: [AreaMaterialType] {
        
        return materialTypes
    }
}

extension Area {
    
    /*!
     @method load:nodes
     @abstract Load all grid nodes from supplied data.
     @property nodes FootpathNodeJSON struct containing grid data.
     */
    public func load(nodes: [AreaNodeJSON]) {
        
        clear()
        
        nodes.forEach { nodeJSON in
            
            guard let areaNode = add(node: nodeJSON.volume.coordinate) else { return }
            
            if let perimeterEdges = nodeJSON.perimeterEdges {
                
                perimeterEdges.forEach { perimeterEdge in
                    
                    areaNode.set(perimeterType: perimeterEdge.perimeterType, edge: perimeterEdge.edge)
                }
            }
            
            if let surfaceType = nodeJSON.surfaceType {
                
                areaNode.surfaceType = find(surfaceType: surfaceType)
            }
            
            if let externalPrefabType = nodeJSON.externalPrefabType {
                
                areaNode.externalPrefabType = externalPrefabType
            }
            
            if let internalPrefabType = nodeJSON.internalPrefabType {
                
                areaNode.internalPrefabType = internalPrefabType
            }
        }
    }
}

extension Area {
    
    /*!
     @method add:node
     @abstract Attempt to create and return a new grid node at the requested coordinate.
     @param coordinate The coordinate used to define the volume the grid node should occupy.
     */
    public func add(node coordinate: Coordinate) -> AreaNode? {
        
        let volume = AreaNode.FixedVolume(coordinate)
        
        if let node = add(node: volume) {
            
            GridEdge.Edges.forEach { edge in
                
                if let neighbour = find(node: volume.coordinate + GridEdge.Cardinal(edge: edge)) {
                    
                    node.add(neighbour: neighbour, edge: edge)
                }
            }
            
            node.surfaceType = availableSurfaceTypes.first
            node.externalMaterialType = availableMaterialTypes.first
            node.internalMaterialType = availableMaterialTypes.first
            
            return node
        }
        
        return nil
    }
    
    /*!
     @method remove:node
     @abstract Attempt to find and remove the specified node.
     @param node The node to be found and removed.
     */
    public func remove(node: AreaNode) -> Bool {
        
        return false
    }
}

extension Area {
    
    /*!
     @method loadSurfaceTypes
     @abstract Load AreaSurfaceTypes from disc.
     */
    func loadSurfaceTypes() {
        
        do {
            
            let path = Bundle.meadow.path(forResource: "area_surface_types", ofType: "json")!
            
            let jsonData = try NSData(contentsOfFile: path) as Data
            
            let decoder = JSONDecoder()
            
            surfaceTypes = try decoder.decode([AreaSurfaceType].self, from: jsonData)
        }
        catch {
            
            fatalError("Unable to load area surface types")
        }
    }
    
    /*!
     @method find:surfaceType
     @abstract Attempt to find and return the appropriate AreaSurfaceType with a matching name.
     @param name The name of the AreaSurfaceType to be found and returned.
     */
    public func find(surfaceType name: String) -> AreaSurfaceType? {
        
        return surfaceTypes.first { surfaceType -> Bool in
            
            return surfaceType.name == name
        }
    }
}

extension Area {
    
    /*!
     @method loadMaterialTypes
     @abstract Load AreaMaterialTypes from disc.
     */
    func loadMaterialTypes() {
        
        do {
            
            let path = Bundle.meadow.path(forResource: "area_material_types", ofType: "json")!
            
            let jsonData = try NSData(contentsOfFile: path) as Data
            
            let decoder = JSONDecoder()
            
            materialTypes = try decoder.decode([AreaMaterialType].self, from: jsonData)
        }
        catch {
            
            fatalError("Unable to load area material types")
        }
    }
    
    /*!
     @method find:materialType
     @abstract Attempt to find and return the appropriate AreaMaterialType with a matching name.
     @param name The name of the AreaMaterialType to be found and returned.
     */
    public func find(materialType name: String) -> AreaMaterialType? {
        
        return materialTypes.first { materialType -> Bool in
            
            return materialType.name == name
        }
    }
}
