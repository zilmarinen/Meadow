//
//  Area.swift
//  Meadow
//
//  Created by Zack Brown on 01/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Foundation

public class Area: Grid<AreaChunk, AreaTile, AreaNode<AreaNodeEdge>> {
    
    public enum WallRenderState {
        
        case cutaway
        case raised
    }
    
    public var wallRenderState: WallRenderState {
        
        get {
            
            let cutaway = children.filter { $0.wallRenderState == .cutaway }
            
            return (cutaway.count == totalChildren ? .cutaway : .raised)
        }
        
        set {
            
            children.forEach { $0.wallRenderState = newValue }
        }
    }
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
        
        node.floorColorPalette = ArtDirector.shared?.palettes.children.last
        
        GridEdge.Edges.forEach { edge in
            
            if let neighbour = find(node: coordinate + GridEdge.extent(edge: edge)) {
                
                node.add(neighbour: neighbour, edge: edge)
            }
        }
        
        return node
    }
}
