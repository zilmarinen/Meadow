//
//  Area.swift
//  Meadow
//
//  Created by Zack Brown on 01/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Foundation

public class Area: Grid<AreaChunk, AreaTile, AreaNode<AreaNodeEdge>> {
    
}

extension Area: SceneGraphIntermediate {
    
    public typealias IntermediateType = AreaNodeIntermediate
    
    public func load(intermediates: [IntermediateType]) {
        
        intermediates.forEach { intermediate in
            
            if let node = add(node: intermediate.volume.coordinate) {
                
                intermediate.children.forEach { nodeEdgeIntermediate in
                    
                    //
                }
            }
        }
    }
}

extension Area {
    
    public func add(node coordinate: Coordinate) -> AreaNode<AreaNodeEdge>? {
        
        guard let node = add(node: AreaNodeEdge.fixedVolume(coordinate)) else { return nil }
        
        GridEdge.Edges.forEach { edge in
            
            if let neighbour = find(node: coordinate + GridEdge.extent(edge: edge)) {
                
                node.add(neighbour: neighbour, edge: edge)
            }
        }
        
        return node
    }
    
    public func find(edge coordinate: Coordinate, edge: GridEdge) -> AreaNodeEdge? {
        
        return find(node: coordinate)?.find(edge: edge)
    }
    
    @discardableResult public func remove(edge: AreaNodeEdge) -> Bool {
        
        guard let node = find(node: edge.volume.coordinate) else { return false }
        
        return node.remove(edge: edge)
    }
}

extension Area {
    
    public var renderState: AreaNodeEdge.RenderState {
        
        get {
            
            let cutaway = children.filter { $0.renderState == .cutaway }
            
            return (cutaway.count == totalChildren ? .cutaway : .raised)
        }
        
        set {
            
            children.forEach { $0.renderState = newValue }
        }
    }
}
