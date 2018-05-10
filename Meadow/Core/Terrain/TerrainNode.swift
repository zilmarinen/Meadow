//
//  TerrainNode.swift
//  Meadow
//
//  Created by Zack Brown on 27/04/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

public class TerrainNode: GridNode {
    
    private var neighbours: Set<GridNodeNeighbour> = []
    
    private var layers: [TerrainLayer] = []
    
    public var topLayer: TerrainLayer? {
        
        return layers.max(by: { (lhs, rhs) -> Bool in
            
            return lhs.polyhedron.upperPolytope.peak < rhs.polyhedron.upperPolytope.peak
        })
    }
}

extension TerrainNode {
    
    func add(neighbour node: TerrainNode, edge: GridEdge) {
        
        if node.volume.coordinate.adjacency(to: volume.coordinate) != .adjacent {
            
            return
        }
     
        remove(neighbour: edge)
        
        neighbours.insert(GridNodeNeighbour(edge: edge, node: node))
        
        let oppositeEdge = GridEdge.Opposite(edge: edge)
        
        if node.find(neighbour: oppositeEdge) == nil {
            
            node.add(neighbour: self, edge: oppositeEdge)
        }
        
        becomeDirty()
    }
    
    func remove(neighbour edge: GridEdge) {
        
        if let neighbour = find(neighbour: edge) {
            
            neighbours.remove(neighbour)
            
            guard let neighbouringNode = neighbour.node as? TerrainNode else { return }
            
            let oppositeEdge = GridEdge.Opposite(edge: edge)
            
            if let _ = neighbouringNode.find(neighbour: oppositeEdge) {
                
                neighbouringNode.remove(neighbour: oppositeEdge)
            }
            
            becomeDirty()
        }
    }
    
    func find(neighbour edge: GridEdge) -> GridNodeNeighbour? {
        
        return neighbours.first { neighbour -> Bool in
        
            return neighbour.edge == edge
        }
    }
}

extension TerrainNode {
    
    public func add(layer terrainType: TerrainType) -> TerrainLayer? {
        
        if let topLayer = topLayer {
            
            if World.Y(y: topLayer.polyhedron.upperPolytope.base) == World.Ceiling {
                
                return nil
            }
        }
        
        let layer = TerrainLayer(node: self, terrainType: terrainType)
        
        let currentTopLayer = topLayer
        
        layer.hierarchy.lower = currentTopLayer
        
        layers.append(layer)
        
        currentTopLayer?.hierarchy.upper = layer
        
        let height = (layer.hierarchy.lower != nil ? World.Y(y: layer.hierarchy.lower!.polyhedron.upperPolytope.peak) : World.Floor) + 1
        
        GridCorner.Corners.forEach { corner in
            
            layer.set(height: height, corner: corner)
        }
        
        becomeDirty()
        
        return layer
    }
    
    public func remove(layer: TerrainLayer) {
        
        if let index = layers.index(of: layer) {
            
            layers.remove(at: index)
            
            if let upper = layer.hierarchy.upper {
                
                upper.hierarchy.lower = layer.hierarchy.lower
            }
            
            if let lower = layer.hierarchy.lower {
                
                lower.hierarchy.upper = layer.hierarchy.upper
            }
            
            layer.hierarchy.upper = nil
            layer.hierarchy.lower = nil
            
            becomeDirty()
        }
    }
}
