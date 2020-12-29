//
//  Blueprint.swift
//
//  Created by Zack Brown on 27/12/2020.
//

import SceneKit

public class Blueprint: SCNNode, Responder, SceneGraphNode, Soilable {
    
    enum Constants {
        
        static let blueColor = Color(red: 0.09, green: 0.82, blue: 0.85)
        static let greenColor = Color(red: 0.72, green: 0.87, blue: 0.43)
        static let redColor = Color(red: 1.0, green: 0.27, blue: 0.27)
    }
    
    public var ancestor: SoilableParent?
    
    public var isDirty: Bool = false
    
    public var children: [SceneGraphNode] { [] }
    public var childCount: Int { children.count }
    public var isLeaf: Bool { children.isEmpty }
    public var category: Int { SceneGraphCategory.blueprint.rawValue }
    
    public lazy var controller: BlueprintController = {
       
        return BlueprintController(initialState: .empty)
    }()
    
    override init() {
        
        super.init()
        
        name = "Blueprint"
        categoryBitMask = category
        
        controller.subscribe(stateDidChange(from:to:))
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
}

extension Blueprint {
    
    @discardableResult public func clean() -> Bool {
        
        guard isDirty else { return false }
        
        //
        
        isDirty = false
        
        return true
    }
}

extension Blueprint {
    
    func stateDidChange(from previousState: BlueprintState?, to currentState: BlueprintState) {
        
        DispatchQueue.main.async { [weak self] in
            
            guard let self = self else { return }
            
            switch currentState {
            
            case .empty: self.clear()
            case .area(let bounds, let blueprintType, let elevation): self.select(area: bounds, blueprintType: blueprintType, elevation: elevation)
            case .foliage(let bounds, let blueprintType, let elevation): self.select(foliage: bounds, blueprintType: blueprintType, elevation: elevation)
            case .footpath(let bounds, let blueprintType, let elevation): self.select(footpath: bounds, blueprintType: blueprintType, elevation: elevation)
            case .portal(let bounds, let blueprintType, let elevation): self.select(portal: bounds, blueprintType: blueprintType, elevation: elevation)
            case .prop(let bounds, let blueprintType, let elevation): self.select(prop: bounds, blueprintType: blueprintType, elevation: elevation)
            case .terrain(let bounds, let blueprintType, let elevation): self.select(terrain: bounds, blueprintType: blueprintType, elevation: elevation)
            }
        }
    }
}

extension Blueprint {
    
    func clear() {
        
        print("Blueprint -> Empty")
        
        self.geometry = nil
    }
    
    func select(area bounds: GridBounds, blueprintType: BlueprintType, elevation: Int) {
        
        guard let scene = scene else { return }
        
        print("Blueprint -> Area(\(bounds), \(blueprintType))")
        
        var polygons: [Polygon] = []
        
        bounds.enumerate(y: elevation) { coordinate in
            
            let tile = scene.meadow.area.find(tile: coordinate)
            
            let vector = Vector(coordinate: coordinate.xz)
            
            let corners = Ordinal.allCases.map { vector + $0.vector + Vector(x: 0, y: (Double(tile?.coordinate.y ?? 0) * World.Constants.slope) + (Math.epsilon * 2.0), z: 0) }
            
            let normal = corners.normal()
            
            let color = self.color(for: blueprintType, hasTile: tile == nil)
            
            var vertices: [Vertex] = []
            
            for index in 0..<corners.count {
                
                let corner = corners[index]
                
                vertices.append(Vertex(position: corner, normal: normal, color: color))
            }
            
            polygons.append(Polygon(vertices: vertices))
        }
        
        let mesh = Mesh(polygons: polygons)
        
        self.geometry = SCNGeometry(mesh: mesh)
    }
    
    func select(foliage bounds: GridBounds, blueprintType: BlueprintType, elevation: Int) {
        
        print("Blueprint -> Foliage(\(bounds), \(blueprintType))")
    }
    
    func select(footpath bounds: GridBounds, blueprintType: BlueprintType, elevation: Int) {
        
        guard let scene = scene else { return }
        
        print("Blueprint -> Footpath(\(bounds), \(blueprintType))")
        
        var polygons: [Polygon] = []
        
        bounds.enumerate(y: elevation) { coordinate in
            
            let tile = scene.meadow.footpath.find(tile: coordinate)
            
            let vector = Vector(coordinate: coordinate.xz)
            
            let corners = Ordinal.allCases.map { vector + $0.vector + Vector(x: 0, y: (Double(tile?.coordinate.y ?? 0) * World.Constants.slope) + (Math.epsilon * 2.0), z: 0) }
            
            let normal = corners.normal()
            
            let color = self.color(for: blueprintType, hasTile: tile == nil)
            
            var vertices: [Vertex] = []
            
            for index in 0..<corners.count {
                
                let corner = corners[index]
                
                vertices.append(Vertex(position: corner, normal: normal, color: color))
            }
            
            polygons.append(Polygon(vertices: vertices))
        }
        
        let mesh = Mesh(polygons: polygons)
        
        self.geometry = SCNGeometry(mesh: mesh)
    }
    
    func select(portal bounds: GridBounds, blueprintType: BlueprintType, elevation: Int) {
        
        print("Blueprint -> Portal(\(bounds), \(blueprintType))")
    }
    
    func select(prop bounds: GridBounds, blueprintType: BlueprintType, elevation: Int) {
        
        print("Blueprint -> Prop(\(bounds), \(blueprintType))")
    }
    
    func select(terrain bounds: GridBounds, blueprintType: BlueprintType, elevation: Int) {
        
        guard let scene = scene else { return }
        
        print("Blueprint -> Terrain(\(bounds), \(blueprintType))")
        
        var polygons: [Polygon] = []
        
        bounds.enumerate(y: elevation) { coordinate in
            
            let tile = scene.meadow.terrain.find(tile: coordinate)
            
            let vector = Vector(coordinate: coordinate.xz)
            
            let corners = Ordinal.allCases.map { vector + $0.vector + Vector(x: 0, y: (Double(tile?.coordinate.y ?? 0) * World.Constants.slope) + (Math.epsilon * 2.0), z: 0) }
            
            let normal = corners.normal()
            
            let color = self.color(for: blueprintType, hasTile: tile == nil)
            
            var vertices: [Vertex] = []
            
            for index in 0..<corners.count {
                
                let corner = corners[index]
                
                vertices.append(Vertex(position: corner, normal: normal, color: color))
            }
            
            polygons.append(Polygon(vertices: vertices))
        }
        
        let mesh = Mesh(polygons: polygons)
        
        self.geometry = SCNGeometry(mesh: mesh)
    }
    
    func color(for blueprintType: BlueprintType, hasTile: Bool) -> Color {
        
        switch blueprintType {
        
        case .add:
            
            return hasTile ? Constants.blueColor : Constants.greenColor
            
        case .remove:
            
            return hasTile ? Constants.redColor : Constants.blueColor
            
        case .select:
            
            return hasTile ? Constants.greenColor : Constants.blueColor
        }
    }
}
