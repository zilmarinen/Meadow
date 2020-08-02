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
    
    public var edges: [Int : E] = [:]
    
    public override func encode(to encoder: Encoder) throws {
        
        try super.encode(to: encoder)
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(Array(edges.values), forKey: .edges)
    }
    
    public override func child(didBecomeDirty child: SoilableChild) {
        
        ancestor?.child(didBecomeDirty: child)
        
        becomeDirty()
        
        guard let edge = child as? E, let neighbour = find(neighbour: edge.identifier) else { return }
        
        neighbour.becomeDirty()
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
        
        for (identifier, edge) in edges where !edge.isHidden {
            
            if let polys = build(edge: identifier) {

                polygons.append(contentsOf: polys)
            }
        }
        
        return Mesh(polygons: polygons)
    }
    
    public override var children: [SceneGraphNode] { return Array(edges.values) }
    
    func numberOfPolyhedrons(for edge: Int) -> Int {
        
        return find(edge: edge)?.layers.count ?? 0
    }
    
    func neighbourIndices(for edge: Int) -> (i0: Int, i1: Int) {
        
        guard let edgeIndex = joints.firstIndex(of: edge) else { return (-1, -1) }
        
        let i0 = ((edgeIndex - 1 + joints.count) % joints.count)
        let i1 = ((edgeIndex + 1) % joints.count)
        
        return (i0: joints[i0], i1: joints[i1])
    }
    
    func polytope(forApex edge: Int, atIndex index: Int) -> GridMesh.Polytope? {

        guard let layer = find(edge: edge)?.find(layer: index) else { return nil }
        
        let (v0, centre, v1) = vertices(for: edge)

        let p0 = GridMesh.Elevation(elevation: layer.corners.left.elevation, vector: v0)
        let p1 = GridMesh.Elevation(elevation: layer.corners.centre.elevation, vector: centre)
        let p2 = GridMesh.Elevation(elevation: layer.corners.right.elevation, vector: v1)

        return GridMesh.Polytope(p0: p0, p1: p1, p2: p2)
    }

    func polytope(forThrone edge: Int, atIndex index: Int) -> GridMesh.Polytope? {

        guard let layer = find(edge: edge)?.find(layer: index) else { return nil }

        let (v0, centre, v1) = vertices(for: edge)

        let corners = layer.lower?.corners ?? LayerCorners(left: -1, right: -1, center: -1)

        let p0 = GridMesh.Elevation(elevation: corners.left.elevation, vector: v0)
        let p1 = GridMesh.Elevation(elevation: corners.centre.elevation, vector: centre)
        let p2 = GridMesh.Elevation(elevation: corners.right.elevation, vector: v1)

        return GridMesh.Polytope(p0: p0, p1: p1, p2: p2)
    }
    
    func shouldRender(face edge: Int, atIndex index: Int) -> Bool {
        
        guard let layers = find(edge: edge)?.layers else { return false }

        return !layers[index].isHidden
    }

    func colorPalette(apex edge: Int, atIndex index: Int) -> ColorPalette { return .default }
    func colorPalette(face edge: Int, atIndex index: Int) -> ColorPalette { return .default }

    func apex(for edge: Int, polyhedron: GridMesh.Polyhedron, atIndex index: Int) -> Pasture.Polygon? {

        guard shouldRender(apex: edge, atIndex: index), let edgeIndex = joints.firstIndex(of: edge) else { return nil }

        let normal = polyhedron.upper.normal

        let color = colorPalette(apex: edge, atIndex: index)

        let v0 = Vertex(position: polyhedron.upper.p0.vector, normal: normal, color: color.primary, textureCoordinates: CGPoint.uvs[edgeIndex])
        let v1 = Vertex(position: polyhedron.upper.p1.vector, normal: normal, color: color.primary, textureCoordinates: CGPoint.uvs.last!)
        let v2 = Vertex(position: polyhedron.upper.p2.vector, normal: normal, color: color.primary, textureCoordinates: CGPoint.uvs[((edgeIndex + 1) % joints.count)])

        return Pasture.Polygon(vertices: [v0, v1, v2])
    }

    func side(for edge: Int, face: GridMesh.Face, intersection: GridMesh.EdgeSegment?, atIndex index: Int) -> [Pasture.Polygon]? {
        
        guard shouldRender(face: edge, atIndex: index) else { return nil }

        guard let face = (intersection != nil ? face.clip(intersection: intersection!) : face) else { return nil }

        let color = colorPalette(face: edge, atIndex: index)

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
    
    public func add(edge identifier: Int) -> E {
        
        let edge = find(edge: identifier) ?? E(ancestor: self, identifier: identifier)
        
        if edge.layers.isEmpty {
            
            let _ = edge.addLayer()
        }
        
        self.edges.updateValue(edge, forKey: identifier)
        
        return edge
    }
    
    public func find(edge identifier: Int) -> E? {
        
        return edges[identifier]
    }
    
    public func remove(edge identifier: Int) {
        
        if find(edge: identifier) != nil {
            
            edges.removeValue(forKey: identifier)
            
            becomeDirty()
            
            if let neighbour = find(neighbour: identifier), let connectedEdge = neighbour.find(edge: identifier) {
                
                connectedEdge.becomeDirty()
            }
        }
    }
}

extension LayeredTile {
    
    func intersection(for edge: Int, neighbour: Int) -> GridMesh.EdgeSegment? {
        
        guard let edgeIndex = joints.firstIndex(of: edge) else { return nil }

        let (v0, centre, v1) = vertices(for: edge)

        if edge == neighbour {
            
            guard let layer = find(neighbour: edge)?.find(edge: edge)?.topLayer else { return nil }
            
            return GridMesh.EdgeSegment(e0: layer.corners.right.elevation, v0: v0, e1: layer.corners.left.elevation, v1: v1)
        }
        
        guard let layer = find(edge: neighbour)?.topLayer, let neighbourIndex = joints.firstIndex(of: neighbour) else { return nil }

        let rightNeighbour = !(neighbourIndex == ((edgeIndex + 1) % joints.count))
        
        let v3 = (rightNeighbour ? v1 : centre)
        let v4 = (rightNeighbour ? centre : v0)

        let left = (rightNeighbour ? layer.corners.left : layer.corners.centre)
        let right = (rightNeighbour ? layer.corners.centre : layer.corners.right)

        return GridMesh.EdgeSegment(e0: left.elevation, v0: v3, e1: right.elevation, v1: v4)
    }
    
    func normal(for edge: Int, neighbour: Int) -> Vector {
        
        let (v0, centre, v1) = vertices(for: edge)
        
        if edge == neighbour {
            
            return (v0 - v1).cross(vector: (v1 + .up) - v1)
        }
        
        guard let edgeIndex = joints.firstIndex(of: edge), let neighbourIndex = joints.firstIndex(of: neighbour) else { return .zero }

        if (neighbourIndex == ((edgeIndex + 1) % joints.count)) {
        
            return (centre - v0).cross(vector: (v0 + .up) - v0)
        }
        
        return (v1 - centre).cross(vector: (centre + .up) - centre)
    }
    
    func vertices(for edge: Int) -> (v0: Vector, centre: Vector, v1: Vector) {
    
        guard let edgeIndex = joints.firstIndex(of: edge)  else { return (.zero, .zero, .zero) }
        
        return (v0: vectors[((edgeIndex + 1) % joints.count)], centre: centre, v1: vectors[edgeIndex])
    }
    
    func shouldRender(apex edge: Int, atIndex index: Int) -> Bool {

        guard let layers = find(edge: edge)?.layers else { return false }

        let layer = layers[index]

        return !layer.isHidden && (layer.upper == nil || layer.upper?.isHidden ?? false)
    }
}
