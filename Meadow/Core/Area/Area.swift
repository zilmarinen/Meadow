//
//  Area.swift
//  Meadow
//
//  Created by Zack Brown on 01/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Foundation

public class Area: Grid<AreaChunk, AreaTile, AreaNode> {
    
}

extension Area: SceneGraphIntermediate {
    
    public typealias IntermediateType = AreaNodeIntermediate
    
    public func load(intermediates: [IntermediateType]) {
        
        intermediates.forEach { intermediate in
            
            if let node = add(node: intermediate.volume.coordinate) {
                
                node.externalAreaType = intermediate.externalAreaType
                node.internalAreaType = intermediate.internalAreaType
                node.floorColorPalette = ArtDirector.shared?.palette(named: intermediate.floorColorPalette)
                
                GridEdge.Edges.forEach { edge in
                    
                    if let nodeEdge = intermediate.edges.find(edge: edge), let externalColorPalette = ArtDirector.shared?.palette(named: nodeEdge.externalColorPalette), let internalColorPalette = ArtDirector.shared?.palette(named: nodeEdge.internalColorPalette) {
                        
                        node.set(edge: AreaNode.Edge(edge: edge, edgeType: nodeEdge.edgeType, architectureType: nodeEdge.architectureType, externalColorPalette: externalColorPalette, internalColorPalette: internalColorPalette))
                    }
                }
            }
        }
    }
}

extension Area {
    
    public func add(node coordinate: Coordinate) -> AreaNode? {
        
        guard let node = add(node: AreaNode.fixedVolume(coordinate)) else { return nil }
        
        node.externalAreaType = AreaType.brick
        node.internalAreaType = AreaType.concrete
        node.floorColorPalette = ArtDirector.shared?.palettes.children.first
        
        GridEdge.Edges.forEach { edge in
            
            if let neighbour = find(node: coordinate + GridEdge.extent(edge: edge)) {
                
                node.add(neighbour: neighbour, edge: edge)
            }
        }
        
        return node
    }
}
