//
//  Footpath.swift
//  Meadow
//
//  Created by Zack Brown on 27/04/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Foundation

/*!
 @class Footpath
 @abstract Footpath is a Grid type that manages the addition and removal of FootpathNodes.
 */
public class Footpath: Grid<FootpathChunk, FootpathTile, FootpathNode> {
    
    /*!
     @property nodeName
     @abstract Returns the name of the SceneGraphNode.
     */
    override public var nodeName: String { return "Footpaths" }
    
    /*!
     @property footpathTypes
     @abstract Array of FootpathTypes loaded from disc.
     */
    var footpathTypes: [FootpathType] = []
    
    /*!
     @property availableFootpathTypes
     @abstract Returns a reference to the FootpathTypes currently loaded.
     */
    public var availableFootpathTypes: [FootpathType] {
        
        return footpathTypes
    }
}

extension Footpath {
    
    /*!
     @method load:nodes
     @abstract Load all grid nodes from supplied data.
     @property nodes FootpathNodeJSON struct containing grid data.
     */
    public func load(nodes: [FootpathNodeJSON]) {
        
        clear()
        
        nodes.forEach { nodeJSON in
            
            guard let footpathNode = add(node: nodeJSON.volume.coordinate) else { return }
            
            footpathNode.slope = nodeJSON.slope
            
            if let footpathType = nodeJSON.footpathType {
                
                footpathNode.footpathType = find(footpathType: footpathType)
            }
        }
    }
}

extension Footpath {
    
    /*!
     @method add:node
     @abstract Attempt to create and return a new grid node at the requested coordinate.
     @param coordinate The coordinate used to define the volume the grid node should occupy.
     */
    public func add(node coordinate: Coordinate) -> FootpathNode? {
        
        let volume = FootpathNode.FixedVolume(coordinate)
        
        if let node = add(node: volume) {
            
            node.footpathType = availableFootpathTypes.first
            
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

extension Footpath {
    
    /*!
     @method loadFootpathTypes
     @abstract Load FootpathTypes from disc.
     */
    func loadFootpathTypes() {
        
        do {
            
            let path = Bundle.meadow.path(forResource: "footpath_types", ofType: "json")!
            
            let jsonData = try NSData(contentsOfFile: path) as Data
            
            let decoder = JSONDecoder()
            
            footpathTypes = try decoder.decode([FootpathType].self, from: jsonData)
        }
        catch {
            
            fatalError("Unable to load footpath types")
        }
    }
    
    /*!
     @method find:footpathType
     @abstract Attempt to find and return the appropriate FootpathType with a matching name.
     @param name The name of the FootpathType to be found and returned.
     */
    public func find(footpathType name: String) -> FootpathType? {
        
        return footpathTypes.first { footpathType -> Bool in
            
            return footpathType.name == name
        }
    }
}
