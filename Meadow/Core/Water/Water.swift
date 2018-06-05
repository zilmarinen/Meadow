//
//  Water.swift
//  Meadow
//
//  Created by Zack Brown on 01/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

/*!
 @class Water
 @abstract Water is a Grid type that manages the addition and removal of WaterNodes.
 */
public class Water: Grid<WaterChunk, WaterTile, WaterNode> {
    
    /*!
     @property nodeName
     @abstract Returns the name of the SceneGraphNode.
     */
    override public var nodeName: String { return "Water" }
    
    /*!
     @property waterTypes
     @abstract Array of FootpathTypes loaded from disc.
     */
    var waterTypes: [WaterType] = []
    
    /*!
     @property availableWaterTypes
     @abstract Returns a reference to the WaterTypes currently loaded.
     */
    public var availableWaterTypes: [WaterType] {
        
        return waterTypes
    }
}

extension Water {
    
    /*!
     @method load:nodes
     @abstract Load all grid nodes from supplied data.
     @property nodes WaterNodeJSON struct containing grid data.
     */
    public func load(nodes: [WaterNodeJSON]) {
        
        clear()
        
        nodes.forEach { nodeJSON in
            
            guard let waterNode = add(node: nodeJSON.volume.coordinate) else { return }
            
            waterNode.waterLevel = nodeJSON.waterLevel
            waterNode.waterType = find(waterType: nodeJSON.waterType)
        }
    }
}

extension Water {

    /*!
     @method add:node
     @abstract Attempt to create and return a new grid node at the requested coordinate.
     @param coordinate The coordinate used to define the volume the grid node should occupy.
     */
    public func add(node coordinate: Coordinate) -> WaterNode? {
        
        let volume = GridTile.FixedVolume(coordinate)
        
        if let node = add(node: volume) {
            
            node.waterLevel = coordinate.y
            node.waterType = availableWaterTypes.first
            
            return node
        }
        
        return nil
    }
    
    /*!
     @method remove:node
     @abstract Attempt to find and remove the specified node.
     @param node The node to be found and removed.
     */
    public func remove(node: FootpathNode) -> Bool {
        
        return false
    }
}

extension Water {
    
    /*!
     @method loadWaterTypes
     @abstract Load WaterTypes from disc.
     */
    func loadWaterTypes() {
        
        do {
            
            let path = Bundle.meadow.path(forResource: "water_types", ofType: "json")!
            
            let jsonData = try NSData(contentsOfFile: path) as Data
            
            let decoder = JSONDecoder()
            
            waterTypes = try decoder.decode([WaterType].self, from: jsonData)
        }
        catch {
            
            fatalError("Unable to load water types")
        }
    }
    
    /*!
     @method find:waterType
     @abstract Attempt to find and return the appropriate WaterType with a matching name.
     @param name The name of the WaterType to be found and returned.
     */
    public func find(waterType name: String) -> WaterType? {
        
        return waterTypes.first { waterType -> Bool in
            
            return waterType.name == name
        }
    }
}
