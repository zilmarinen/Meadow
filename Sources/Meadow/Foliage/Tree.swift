//
//  Tree.swift
//
//  Created by Zack Brown on 05/01/2021.
//

class Tree: Mesh {
    
    init(sides: Int, pointy: Bool = false) {
        
        let sides = Math.clamp(value: sides, minimum: 3, maximum: 10)
        
        let step = Math.radians(degrees: 360 / Double(sides))
        
        let stumpRadius = 0.125
        let treeRadius = 0.25
        let stump = Vector(x: 0, y: 0.25, z: 0)
        let tree = Vector(x: 0, y: 1.0, z: 0)
        
        var polygons: [Polygon] = []
        
        var angle = step * Double(sides - 1)
        var p0 = Math.plot(angle: angle, radius: stumpRadius)
        var p2 = Math.plot(angle: angle, radius: treeRadius)
        
        for side in 0..<sides {
            
            angle = step * Double(side)
            
            let p1 = Math.plot(angle: angle, radius: stumpRadius)
            let p3 = Math.plot(angle: angle, radius: treeRadius)
            
            //
            //
            //
            var v0 = Vector(x: Double(p0.x), y: 0.0, z: Double(p0.y))
            var v1 = Vector(x: Double(p1.x), y: 0.0, z: Double(p1.y))
            
            var vectors = [v1, v0, v0 + stump, v1 + stump]
            
            var normal = vectors.normal()
            
            var vertices = vectors.map { Vertex(position: $0, normal: normal, color: Color(red: 0.87, green: 0.56, blue: 0.38)) }
            
            polygons.append(Polygon(vertices: vertices))
            
            //
            //
            //
            v0 = Vector(x: Double(p2.x), y: 0.0, z: Double(p2.y)) + stump
            v1 = Vector(x: Double(p3.x), y: 0.0, z: Double(p3.y)) + stump
            
            if pointy {
                
                vectors = [v1, v0, stump + tree]
            }
            else {
                
                vectors = [v1, v0, v0 + tree, v1 + tree]
            }
            
            normal = vectors.normal()
            
            vertices = vectors.map { Vertex(position: $0, normal: normal, color: Color(red: 0.61, green: 0.67, blue: 0.52)) }
            
            polygons.append(Polygon(vertices: vertices))
            
            //
            //
            //
            
            if !pointy {
                
                vectors = [v0 + tree, stump + tree, v1 + tree]
                
                normal = vectors.normal()
                
                vertices = vectors.map { Vertex(position: $0, normal: normal, color: Color(red: 0.61, green: 0.67, blue: 0.52)) }
                
                polygons.append(Polygon(vertices: vertices))
            }
            
            //
            p0 = p1
            p2 = p3
        }
        
        super.init(polygons: polygons)
    }
}
