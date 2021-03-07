//
//  LayeredGrid.swift
//
//  Created by Zack Brown on 26/01/2021.
//

public class LayeredGrid<C: Chunk<T>, T: LayeredTile<L>, L: Layer>: Grid<C, T> {
    
}
    
extension LayeredGrid {
    
    public typealias LayerConfiguration = ((L) -> Void)
    
    public func add(layer coordinate: Coordinate, configure: LayerConfiguration? = nil) -> L? {
        
        let chunk = find(chunk: coordinate) ?? C(coordinate: coordinate)
        
        guard let tile = chunk.find(tile: coordinate) ?? chunk.add(tile: coordinate) else { return nil }
        
        let layer = tile.add(layer: coordinate.xz)
        
        if chunk.parent == nil {
            
            chunks.append(chunk)
            
            addChildNode(chunk)
        }
        
        for cardinal in Cardinal.allCases {
         
            if let neighbour = find(tile: coordinate + cardinal.coordinate) {
                
                tile.add(neighbour: neighbour, cardinal: cardinal)
            }
        }
        
        configure?(layer)
        
        becomeDirty()
        
        return layer
    }
    
    func find(layer coordinate: Coordinate, at index: Int) -> L? {
        
        return find(tile: coordinate)?.find(layer: index)
    }
    
    public func remove(layer coordinate: Coordinate, at index: Int) {
        
        guard let tile = find(tile: coordinate) else { return }
        
        tile.remove(layer: index)
        
        guard tile.layers.isEmpty else { return }
        
        remove(tile: coordinate)
    }
}
