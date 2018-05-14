//
//  TerrainLayer.swift
//  Meadow
//
//  Created by Zack Brown on 05/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import SceneKit

/*!
 @class TerrainLayer
 @abstract TerrainLayers define an area of space within a TerrainNode represented as a Polyhedron.
 */
public class TerrainLayer {
    
    /*!
     @struct TerrainLayerHierarchy
     @abstract Defines the relationship between upper and lower nodes when stacked.
     */
    public struct TerrainLayerHierarchy {
        
        var upper: TerrainLayer?
        var lower: TerrainLayer?
    }
    
    /*!
     @property isDirty
     @abstract Represents staleness of the layer.
     */
    private var isDirty: Bool = true
    
    /*!
     @property corners
     @abstract Defines the world height values of the layers corners.
     */
    private var corners: [Int]
    
    /*!
     @property cachedPolyhedron
     @abstract Cached version of the Polyhedron calculated after becoming dirty.
     */
    private var cachedPolyhedron: Polyhedron?
    
    /*!
     @property node
     @param node The parent node for the layer.
     */
    unowned let node: TerrainNode
    
    /*!
     @property type
     @param terrainType The terrain type used to paint the layer.
     */
    let type: TerrainType
    
    /*!
     @property hierarchy
     @abstract Defines the relationship between upper and lower nodes when stacked.
     */
    var hierarchy: TerrainLayerHierarchy
    
    /*!
     @property polyhedron
     @abstract Returns a Polyhedron calculated from the world corner heights in relation to any upper and/or lower layers.
     */
    var polyhedron: Polyhedron {
        
        if !isDirty {
            
            return cachedPolyhedron!
        }
        
        let unit = Polytope.Unit
        
        var vertices: [SCNVector3] = []
        
        for index in 0..<corners.count {
            
            vertices.append(SCNVector3(x: SCNFloat(node.volume.coordinate.x) + unit.vertices[index].x, y: World.Y(y: corners[index]), z: SCNFloat(node.volume.coordinate.z) + unit.vertices[index].z))
        }
        
        let upperPolytope = Polytope(vertices: vertices)
        
        var lowerPolytope: Polytope
        
        if hierarchy.lower != nil {
            
            lowerPolytope = hierarchy.lower!.polyhedron.upperPolytope
        }
        else {
            
            lowerPolytope = Polytope(x: SCNFloat(node.volume.coordinate.x), y: World.Y(y: node.volume.coordinate.y), z: SCNFloat(node.volume.coordinate.z))
        }
        
        cachedPolyhedron = Polyhedron(upperPolytope: upperPolytope, lowerPolytope: lowerPolytope)
        
        return cachedPolyhedron!
    }
    
    /*!
     @method init:node:terrainType
     @abstract Creates and initialises a layer with the specified node and terrain type.
     @param node The parent node for the layer.
     @param terrainType The terrain type used to paint the layer.
     */
    
    init(node: TerrainNode, terrainType: TerrainType) {
        
        self.node = node
        
        self.type = terrainType
        
        self.corners = [0, 0, 0, 0]
        
        self.hierarchy = TerrainLayerHierarchy(upper: nil, lower: nil)
    }
}

extension TerrainLayer: Equatable {
    
    /*!
     @method ==
     @abstract Determine the equality of two TerrainLayers.
     */
    public static func == (lhs: TerrainLayer, rhs: TerrainLayer) -> Bool {
        
        return lhs.type == rhs.type && lhs.polyhedron == rhs.polyhedron
    }
}

extension TerrainLayer {
    
    /*!
     @method becomeDirty
     @abstract If not already true, toggle the isDirty flag to true.
     */
    func becomeDirty() {
        
        if isDirty { return }
        
        isDirty = true
        
        node.becomeDirty()
    }
}

extension TerrainLayer {
    
    /*!
     @method set:height:corner:smooth
     @abstract Clamp and set the height of the specified corner to be both within the world bounds and relative to any upper and/or lower nodes.
     @discussion Setting the height of a corner will also constrain any connected corner heights for the layer. Smooth adjustments to neighbouring nodes can also be propagated by setting the `smooth` parameter to `true`.
     @param height The world height of the corner.
     @param corner The corner for which the height should be set.
     @param smooth Determines whether neighbouring nodes should be updated of changes in height.
     */
    func set(height: Int, corner: GridCorner, smooth: Bool = false) {
        
        var value = min(max(height, World.Floor), World.Ceiling)
        
        if let upper = hierarchy.upper {
            
            value = min(value, upper.get(height: corner))
        }
        
        if let lower = hierarchy.lower {
            
            value = max(value, lower.get(height: corner))
        }
        
        if get(height: corner) != value {
         
            corners[corner.rawValue] = value
            
            node.becomeDirty()
            
            let connectedCorners = GridCorner.Corners(corner: corner)
            let oppositeCorner = GridCorner.Opposite(corner: corner)
            
            resolve(height: value, corner: connectedCorners[0], clamp: 1)
            resolve(height: value, corner: connectedCorners[1], clamp: 1)
            resolve(height: value, corner: oppositeCorner, clamp: 2)
            
            if smooth {
                
                let connectedEdges = GridEdge.Edges(corner: corner)
                
                let ce0 = connectedEdges[0]
                let ce1 = connectedEdges[1]
                
                let ac0 = GridCorner.Adjacent(corner: corner, edge: ce0)
                let ac1 = GridCorner.Adjacent(corner: corner, edge: ce1)
                
                let n0 = node.find(neighbour: ce0)?.node as? TerrainNode
                let n1 = node.find(neighbour: ce1)?.node as? TerrainNode
                let n2 = (n0 != nil ? n0!.find(neighbour: ce1) : (n1 != nil ? n1!.find(neighbour: ce0) : nil))?.node as? TerrainNode
                
                if let n0 = n0, let topLayer = n0.topLayer { topLayer.set(height: value, corner: ac0, smooth: smooth) }
                if let n1 = n1, let topLayer = n1.topLayer { topLayer.set(height: value, corner: ac1, smooth: smooth) }
                if let n2 = n2, let topLayer = n2.topLayer { topLayer.set(height: value, corner: oppositeCorner, smooth: smooth) }
            }
        }
    }
    
    /*!
     @method resolve:height:corner:clamp
     @abstract Resolve the height of a corner within the degree of tolerance defined by `clamp`.
     @param height The world height of the corner.
     @param corner The corner for which the height should be set.
     @param clamp Defines a level of tolerance for constraining differences in height.
     */
    func resolve(height: Int, corner: GridCorner, clamp: Int) {
     
        let delta = get(height: corner) - height
        
        if abs(delta) > clamp {
            
            corners[corner.rawValue] = height + (delta <= -clamp ? -clamp : (delta >= clamp ? clamp : delta))
        }
    }
    
    /*!
     @method get:corner
     @abstract Returns the world height of the given corner.
     @param corner The corner to return the world height for.
     */
    func get(height corner: GridCorner) -> Int {
        
        return corners[corner.rawValue]
    }
}

extension TerrainLayer: SceneGraphNode {
    
    /*!
     @property nodeName
     @abstract Returns the name of the SceneGraphNode.
     */
    public var nodeName: String { return "Layer" }
    
    /*!
     @property totalChildren
     @abstract Returns the total number of child SceneGraphNodes for the SceneGraphNode.
     */
    public var totalChildren: Int { return 0 }
    
    /*!
     @method sceneGraph:childAtIndex
     @abstract Attempt to find and return a child SceneGraphNode at the specified index.
     @property index The index of the child SceneGraphNode to be found and returned.
     */
    public func sceneGraph(childAtIndex index: Int) -> SceneGraphNode? {
        
        return nil
    }
}
