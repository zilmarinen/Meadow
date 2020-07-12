//
//  LayeredTile.swift
//  Meadow
//
//  Created by Zack Brown on 18/06/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

import Pasture

public class LayeredTile<E: Edge<L>, L: Layer>: Tile, GridMeshBuilder {
    
    enum CodingKeys: CodingKey {
        
        case edges
    }
    
    public var edges: [Cardinal : E] = [:]
    
    public override func encode(to encoder: Encoder) throws {
        
        try super.encode(to: encoder)
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(edges, forKey: .edges)
    }
    
    public override func child(didBecomeDirty child: SoilableChild) {
        
        ancestor?.child(didBecomeDirty: child)
        
        becomeDirty()
        
        guard let edge = child as? E else { return }
        
        let (c0, c1) = edge.cardinal.cardinals
        
        find(neighbour: edge.cardinal)?.becomeDirty()
        find(edge: c0)?.becomeDirty()
        find(edge: c1)?.becomeDirty()
    }
    
    @discardableResult public override func clean() -> Bool {
        
        guard isDirty else { return false }
        
        edges.forEach { (_, edge) in
            
            edge.clean()
        }
        
        return super.clean()
    }
    
    override func render(transform: Transform) -> Mesh {
        
        guard isDirty else { return self.mesh }
        
        var polygons: [Pasture.Polygon] = []
        
        for (cardinal, edge) in edges where !edge.isHidden {
            
            if let polys = build(cardinal: cardinal) {
                
                polygons.append(contentsOf: polys)
            }
        }
        
        return Mesh(polygons: polygons)
    }
    
    public override var children: [SceneGraphNode] { return Array(edges.values) }
    
    func numberOfPolyhedrons(for cardinal: Cardinal) -> Int {
        
        return find(edge: cardinal)?.layers.count ?? 0
    }
    
    func polytope(forApex cardinal: Cardinal, atIndex index: Int) -> GridMesh.Polytope? {
        
        guard let layer = find(edge: cardinal)?.find(layer: index) else { return nil }
        
        let (o0, o1) = cardinal.ordinals
        
        let v0 = o0.vector + transform.position
        let v1 = transform.position
        let v2 = o1.vector + transform.position
        
        let p0 = GridMesh.Elevation(elevation: layer.corners.left.elevation, vector: v0)
        let p1 = GridMesh.Elevation(elevation: layer.corners.centre.elevation, vector: v1)
        let p2 = GridMesh.Elevation(elevation: layer.corners.right.elevation, vector: v2)
        
        return GridMesh.Polytope(p0: p0, p1: p1, p2: p2)
    }
    
    func polytope(forThrone cardinal: Cardinal, atIndex index: Int) -> GridMesh.Polytope? {
        
        guard let layer = find(edge: cardinal)?.find(layer: index) else { return nil }
        
        let (o0, o1) = cardinal.ordinals
        
        let v0 = o0.vector + transform.position
        let v1 = transform.position
        let v2 = o1.vector + transform.position
        
        let corners = layer.lower?.corners ?? LayerCorners(left: -1, right: -1, center: -1)
        
        let p0 = GridMesh.Elevation(elevation: corners.left.elevation, vector: v0)
        let p1 = GridMesh.Elevation(elevation: corners.centre.elevation, vector: v1)
        let p2 = GridMesh.Elevation(elevation: corners.right.elevation, vector: v2)
        
        return GridMesh.Polytope(p0: p0, p1: p1, p2: p2)
    }
    
    func colorPalette(apex cardinal: Cardinal, atIndex index: Int) -> ColorPalette { return .default }
    func colorPalette(face cardinal: Cardinal, atIndex index: Int) -> ColorPalette { return .default }
    
    func apex(for cardinal: Cardinal, polyhedron: GridMesh.Polyhedron, atIndex index: Int) -> Pasture.Polygon? {
        
        guard shouldRender(apex: cardinal, atIndex: index) else { return nil }
        
        let normal = polyhedron.upper.normal
        
        let color = colorPalette(apex: cardinal, atIndex: index)
        
        let v0 = Vertex(position: polyhedron.upper.p0.vector, normal: normal, color: color.primary, textureCoordinates: CGPoint.uvs[cardinal.rawValue])
        let v1 = Vertex(position: polyhedron.upper.p1.vector, normal: normal, color: color.primary, textureCoordinates: CGPoint.uvs.last!)
        let v2 = Vertex(position: polyhedron.upper.p2.vector, normal: normal, color: color.primary, textureCoordinates: CGPoint.uvs[((cardinal.rawValue + 1) % 4)])
        
        return Pasture.Polygon(vertices: [v0, v1, v2])
    }
    
    func edge(for cardinal: Cardinal, face: GridMesh.Face, intersection: GridMesh.EdgeSegment?, atIndex index: Int) -> [Pasture.Polygon]? {
        
        guard shouldRender(face: cardinal, atIndex: index) else { return nil }
        
        guard let face = (intersection != nil ? face.clip(intersection: intersection!) : face) else { return nil }
        
        let color = colorPalette(face: cardinal, atIndex: index)
        
        let p0Equal = face.upper.p0.elevation == face.lower.p0.elevation
        let p1Equal = face.upper.p1.elevation == face.lower.p1.elevation
        
        if p0Equal || p1Equal {
            
            let p2 = (p0Equal ? face.lower.p1 : face.lower.p0)
            
            let v0 = Vertex(position: face.upper.p0.vector, normal: face.normal, color: color.secondary, textureCoordinates: CGPoint.uvs[0])
            let v1 = Vertex(position: face.upper.p1.vector, normal: face.normal, color: color.secondary, textureCoordinates: CGPoint.uvs[1])
            let v2 = Vertex(position: p2.vector, normal: face.normal, color: color.secondary, textureCoordinates: CGPoint.uvs.last!)
            
            return [Pasture.Polygon(vertices: [v0, v1, v2])]
        }
        
        let v0 = Vertex(position: face.upper.p0.vector, normal: face.normal, color: color.secondary, textureCoordinates: CGPoint.uvs[0])
        let v1 = Vertex(position: face.upper.p1.vector, normal: face.normal, color: color.secondary, textureCoordinates: CGPoint.uvs[1])
        let v2 = Vertex(position: face.lower.p1.vector, normal: face.normal, color: color.secondary, textureCoordinates: CGPoint.uvs[2])
        let v3 = Vertex(position: face.lower.p0.vector, normal: face.normal, color: color.secondary, textureCoordinates: CGPoint.uvs[3])
        
        return [Pasture.Polygon(vertices: [v0, v1, v2, v3])]
    }
}

extension LayeredTile {
    
    public func add(edge cardinal: Cardinal) -> E {
        
        let edge = find(edge: cardinal) ?? E(ancestor: self, coordinate: volume.coordinate, cardinal: cardinal)
        
        if edge.layers.isEmpty {
            
            let _ = edge.addLayer()
        }
        
        self.edges.updateValue(edge, forKey: cardinal)
        
        return edge
    }
    
    public func find(edge cardinal: Cardinal) -> E? {
        
        return edges[cardinal]
    }
    
    public func remove(edge cardinal: Cardinal) {
        
        if find(edge: cardinal) != nil {
            
            edges.removeValue(forKey: cardinal)
            
            becomeDirty()
            
            if let neighbour = find(neighbour: cardinal), let connectedEdge = neighbour.find(edge: cardinal.opposite) {
                
                connectedEdge.becomeDirty()
            }
        }
    }
}

extension LayeredTile {
    
    func intersection(for cardinal: Cardinal, neighbour: Cardinal) -> GridMesh.EdgeSegment? {
        
        let (o0, o1) = cardinal.ordinals
        
        let v0 = o0.vector + transform.position
        let v1 = transform.position
        let v2 = o1.vector + transform.position
        
        if cardinal == neighbour {
            
            guard let layer = find(neighbour: neighbour)?.find(edge: neighbour.opposite)?.topLayer else { return nil }
            
            return GridMesh.EdgeSegment(e0: layer.corners.right.elevation, v0: v0, e1: layer.corners.left.elevation, v1: v2)
        }
        
        guard let layer = find(edge: neighbour)?.topLayer else { return nil }
        
        let (c0, _) = cardinal.cardinals
        
        let v3 = (neighbour == c0 ? v2 : v1)
        let v4 = (neighbour == c0 ? v1 : v0)
        
        let left = (neighbour == c0 ? layer.corners.left : layer.corners.centre)
        let right = (neighbour == c0 ? layer.corners.centre : layer.corners.right)
        
        return GridMesh.EdgeSegment(e0: left.elevation, v0: v3, e1: right.elevation, v1: v4)
    }
    
    func shouldRender(apex cardinal: Cardinal, atIndex index: Int) -> Bool {
        
        guard let layers = find(edge: cardinal)?.layers else { return false }
        
        let layer = layers[index]
        
        return !layer.isHidden && (layer.upper == nil || layer.upper?.isHidden ?? false)
    }
    
    func shouldRender(face cardinal: Cardinal, atIndex index: Int) -> Bool {
        
        guard let layers = find(edge: cardinal)?.layers else { return false }
        
        return !layers[index].isHidden
    }
}
